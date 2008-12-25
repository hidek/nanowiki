package NanoA::Config;

use strict;
use warnings;
use utf8;

my $inited;
my $data_dir;

sub init_klass {
    return 1 if $inited;
    
    my ($klass, $handler_path) = @_;
    
    # read configuration and setup data directory
    if (open my $fh, '<', 'nanoa-conf.cgi') {
        {
            no utf8;
            my $conf = do { local $/; join '', <$fh> };
            close $fh;
            $conf =~ /(?:^|\n)data_dir\s*=\s*(.*)/
                and $data_dir = $1;
        }
        die "nanoa-conf.cgi に data_dir が設定されていません\n"
            unless $data_dir;
    } else {
        if (! $ENV{HTTP_NANOA_USE_HTACCESS}) {
            die << 'EOT';
この実行環境は .htaccess ファイルによるアクセス制御をサポートしていないため、手動でデータディレクリを作成していただく必要があります。

NanoA をインストールしたディレクトリに nanoa-conf.cgi というファイルを作成し、

「data_dir = NanoAのデータを格納するディレクトリ名」

という書式で、データを保存するディレクトリを指定してください。
EOT
            ;
        }
        $data_dir = 'var';
        if (! -e $data_dir . '/.htaccess') {
            _make_data_dir($data_dir);
            open my $fh, '>', $data_dir . '/.htaccess'
                or die $data_dir . '/.htaccess を作成できません:';
            print $fh "Deny from All\nOrder deny,allow\n";
            close $fh;
        }
    }
    
    # redirect to system password page if necessary
    if (! -e "${data_dir}/system/system_password.conf") {
        _make_data_dir($data_dir);
        if ($handler_path ne 'system/setup') {
            print 'Location: ', NanoA->nanoa_uri, '/system/setup', "\n\n";
            CGI::ExceptionManager::detach();
        }
    }
    
    $inited = 1;
}

sub _make_data_dir {
    my $data_dir = shift;
    return
        if -d $data_dir;
    my $u = umask 077;
    mkdir $data_dir
        or die << "EOT";
データ用のディレクトリ「${data_dir}」が存在しなかったため、作成を試みましたが失敗しました。
nanoa-conf.cgi の設定を確認してください
EOT
    ;
    umask $u;
}

sub new {
    my ($klass, $opts) = @_;
    bless {
        %$opts,
        system_config => undef,
        camelize      => undef,
        loaders       => [
            \&NanoA::Dispatch::load_mojo_template,
            \&NanoA::Dispatch::load_pm,
        ],
        not_found     => 'system/not_found',
        mt_cache_dir  => "/tmp/nanoa.${NanoA::VERSION}.$>.mt_cache",
        $opts ? %$opts : (),
    }, $klass;
}

sub system_config {
    my $self = shift;
    return $self
        if $self->app_name eq 'system';
    $self->{system_config} = NanoA::Dispatch->load_config('system/')
        unless $self->{system_config};
    $self->{system_config};
}

sub prefs {
    my $self = shift;
    my $name = shift;
    my $app_dir = join '/', $self->data_dir, $self->app_name;
    unless (-d $app_dir) {
        mkdir $app_dir
            or die $app_dir . 'を作成できません';
    }
    my $file = "$app_dir/$name.conf";
    # set and return value if necessary
    if (@_) {
        if (defined $_[0]) {
            open my $fh, '>:utf8', $file
                or die 'ファイルを作成できません:' . $file;
            print $fh $_[0];
            close $fh;
        } else {
            unlink $file;
        }
        return $_[0];
    }
    return
        unless -e $file;
    NanoA::read_file($file);
}

sub data_dir { $data_dir }

sub db {
    my $self = shift;
    unless ($self->{db}) {
        NanoA::require_once('DBI.pm');
        my $db_uri = $self->db_uri;
        $self->{db} = DBI->connect($db_uri)
            or die DBI->errstr;
        $self->{db}->{unicode} = 1
            if $db_uri =~ /^dbi:sqlite:/i;
    }
    $self->{db};
}

sub db_uri {
    my $self = shift;
    my $template = $self->prefs('db_uri')
        || $self->system_config->prefs('db_uri')
            || 'dbi:SQLite:' . $self->data_dir() . '/%s.db';
    return sprintf $template, $self->app_name
        if $template =~ /\%s/;
    $template;
}

# override this method to setup hooks
sub init_app {
    my ($self, $app) = @_;
}

sub app_name {
    my $self = shift;
    $self->{app_name};
}

sub camelize {
    my $self = shift;
    $self->{camelize};
}

sub loaders {
    my $self = shift;
    $self->{loaders};
}

sub not_found {
    my $self = shift;
    $self->{not_found};
}

sub mt_cache_dir {
    my $self = shift;
    $self->{mt_cache_dir};
}

"ENDOFMODULE";

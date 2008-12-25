#!/usr/bin/perl
use strict;

my $VERSION = '0.01';

sub sorry ($) {
    print "$_[0]\n";
    exit 1;
}

print "Content-Type: text/plain; charset=utf-8\n\n";

{
    print "Perlバージョンを確認しています...\n";
    my $version = '5.008';
    eval "require $version";
    if ($@) {
        sorry "Perl $version 以上がインストールされていません。このPerlは${]}です";
    }
    print "   * perl $version ->  OK!\n";
}

{
    print "インストールに必要なモジュールが使用可能か確認しています...\n";
    my %required = (
        'IO::Socket::INET' => 0,
        'Digest::MD5'      => 0,
        'URI'              => 0,
    );
    while (my ($mod, $version) = each %required) {
        if ($version) {
            eval "use $mod '$version'";
            if ($@) {
                sorry "必須モジュール $mod ($version) がインストールされていませんでした";
            }
            print "   * $mod ($version) OK!\n";
        } else {
            eval "use $mod";
            if ($@) {
                sorry "必須モジュール $mod がインストールされていませんでした";
            }
            print "   * $mod OK!\n";
        }
    }
}

{
    my $get = sub {
        my $url = shift;

        $url = URI->new($url) unless ref $url;
        my $host = $url->host;
        my $port = $url->port;

        my $sock = IO::Socket::INET->new(
            PeerAddr => $host,
            PeerPort => $port,
            Timeout  => 30
        );
        if (! $sock) {
           sorry "接続に失敗しました: $@";
        }

        $sock->autoflush(1);
        $sock->print("GET $url HTTP/1.0\nHost: $host\n\n");

        my $content = '';
        my $buf;
        while (! eof $sock) {
            my $read = read $sock, $buf, 4096;
            if ($read <= 0) {
                last;
            }
            $content .= $buf;
        }
        return $content;
    };

    my $get_and_save = sub {
        my ($url, $file, $checksum) = @_;

        my $content = $get->($url);

        if (Digest::MD5->add($content)->hexdigest ne $checksum) {
            sorry "URL $url のチェックサムが合いません";
        }

        open(my $fh, '>', $file) or
            sorry "URL $url の保存に失敗しました：$!";
        print $fh $content or
            sorry "URL $url の保存に失敗しました：$!";
        close($fh) or
            sorry "URL $url の保存に失敗しました：$!";

        # XXX - need to change permission
    };


    # get manifest, read from manifest and fetch each file in the manifest
    my $host = 'kazuho.31tools.com';
    my $port = 80;
    my $manifest = get("MANIFEST");
    foreach my $line (split /\n/, $manifest) {
        my($file, $checksum) = split(/\s/, $line);
        my $uri = URI->new();
        $uri->schema('http');
        $uri->host($host);
        $uri->port($port);
        $uri->path(join('/', 'dist', $VERSION, $file));
        get_and_save($uri, $file, $checksum);
    }
    
}

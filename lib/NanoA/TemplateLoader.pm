package NanoA::TemplateLoader;

use strict;
use warnings;
use utf8;

our @ISA;
BEGIN {
    @ISA = qw(NanoA);
};

sub __load {
    my ($config, $module, $path) = @_;
    if (__use_cache($config, $path)) {
        NanoA::load_once($config->mt_cache_dir . "/$path.c", $path);
        return $module;
    }
    my $code = __compile($path, $module);
    local $@;
    eval $code;
    die $@ if $@;
    __update_cache($config, $path, $code)
        if $config->mt_cache_dir;
    NanoA::loaded($path, 1);
}

sub __compile {
    my ($path, $module) = @_;
    NanoA::require_once('Text/MicroTemplate.pm');
    my $t = Text::MicroTemplate->new(
        escape_func => 'NanoA::escape_html',
    );
    $t->parse(NanoA::read_file($path));
    my $code = $t->code();
    my $global = ''; # for now $t->global();
#intentially adds space before 'use', so that it would not be erased by tools/concat.pl
    $code = << "EOT";
package $module;
 use strict;
 use warnings;
use utf8;
our \@ISA;
BEGIN {
    \@ISA = qw(NanoA::TemplateLoader);
};
NanoA::__insert_methods(__PACKAGE__);
$global
sub run {
    my (\$app, \$c) = \@_;
    raw_string($code->());
}
1;
EOT
;
    $code;
}

sub __update_cache {
    my ($config, $path, $code) = @_;
    my $cache_path = $config->mt_cache_dir;
    foreach my $p (split '/', $path) {
        mkdir $cache_path;
        $cache_path .= "/$p";
    }
    $cache_path .= '.c';
    open my $fh, '>:utf8', $cache_path
        or die "failed to create cache file $cache_path";
    print $fh $code;
    close $fh;
}

sub __use_cache {
    my ($config, $path) = @_;
    return unless $config->mt_cache_dir;
    my @orig = stat $path
        or return;
    my @cached = stat $config->mt_cache_dir . "/$path.c"
        or return;
    return $orig[9] < $cached[9];
}

"ENDOFMODULE";


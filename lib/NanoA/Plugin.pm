package NanoA::Plugin;

use strict;
use warnings;
use utf8;

use base qw(NanoA);

sub import {
    my $pkg = caller;
    # plugins loading other plugins should call init_plugin explicitely
    local $@;
    my $pkg_is_plugin;
    eval {
        $pkg_is_plugin = $pkg->is_plugin;
    };
    return if $pkg_is_plugin;
    shift->init_plugin($pkg);
}

# plugins willing to install hooks should overide this method
sub init_plugin {
    my ($klass, $controller) = @_;
}

sub is_plugin { 1 }

1;

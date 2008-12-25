package example::start;

use base qw/NanoA/;

use strict;
use warnings;
use utf8;

sub run {
    my $app = shift;
    $app->render('example/template/start');
}

1;

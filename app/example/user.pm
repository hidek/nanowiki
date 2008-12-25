package example::user;

use base qw/NanoA/;

use strict;
use warnings;
use utf8;

sub run {
    my $self = shift;
    'You are ' . escape_html($self->query->param('id') || 'nanashi');
}

1;

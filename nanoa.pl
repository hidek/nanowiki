use strict;
use warnings;
use utf8;

BEGIN {
    unshift @INC, qw(extlib app)
        unless $ENV{MOD_PERL};
};

CGI::ExceptionManager->run(
    callback   => \&NanoA::Dispatch::dispatch,
    powered_by => 'NanoA',
);

1;

package example::debugscreen;

use base qw(NanoA);

sub run {
    &call_nonexisting_func;
}

1;

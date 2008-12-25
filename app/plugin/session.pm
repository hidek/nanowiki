package plugin::session;

use strict;
use warnings;
use utf8;

use HTTP::Session;
use HTTP::Session::Store::File;
use HTTP::Session::State::Cookie;

use base qw(NanoA::Plugin);

sub init_plugin {
    my ($klass, $controller) = @_;
    # add funcs to caller
    NanoA::register_hook($controller, 'postrun', \&_postrun);
}

sub _postrun {
    my ($app, $bodyref) = @_;
    $app->session->header_filter($app);
}

sub run {
    my $self = shift;
    return $self->render('plugin/template/session');
}

no warnings 'redefine';

sub NanoA::session {
    my $app = shift;
    $app->{stash}->{'plugin::session'} ||= do {
        my $dir = $app->config->data_dir . '/session';
        mkdir $dir;
        HTTP::Session->new(
            store   => HTTP::Session::Store::File->new(
                dir => $dir,
            ),
            state   => HTTP::Session::State::Cookie->new(),
            request => bless(\do { my $o = "" }, 'plugin::session::request'),
            id      => 'HTTP::Session::ID::MD5',
        );
    };
}

package plugin::session::request;
# a dummy object (since cookie parameter can be retrieved via %ENV)
sub header {}

1;

package plugin::mobile;

use strict;
use warnings;
use utf8;

use Encode;

use base qw(NanoA::Plugin);

sub init_plugin {
    my ($klass, $controller) = @_;
    NanoA::register_hook($controller, 'prerun', \&_prerun, 0);
    NanoA::register_hook($controller, 'postrun', \&_postrun, 90);
}

sub _prerun {
    my $app = shift;
    my $charset = _mobile_encoding($app->mobile_agent);
    
    return
        if $charset eq 'utf-8';
    
    # build query object by myself and register it, since in first prerun,
    # there is no query object yet
    $app->query(
        sub {
            NanoA::require_once('CGI/Simple.pm');
            local $CGI::Simple::PARAM_UTF8 = undef;
            my $q = CGI::Simple->new();
            # error occurs when trying to replace contents using Vars
            for my $n ($q->param) {
                my @v = $q->param($n);
                if (@v >= 2) {
                    $_ = decode($charset, $_)
                        for @v;
                    $q->param($n, \@v);
                } else {
                    $q->param($n, decode($charset, $v[0]));
                }
            }
            $q;
        },
    );
}

sub _postrun {
    my ($app, $bodyref) = @_;
    my $charset = _mobile_encoding($app->mobile_agent);
    
    return
        if $charset eq 'utf-8';
    
    $app->header(
        -charset => $charset eq 'cp932' ? 'Shift_JIS' : $charset,
    );
    $$bodyref = encode($charset, $$bodyref);
}

# taken from MENTA
sub _mobile_encoding {
    my $ma = shift;
    return 'utf-8' if $ma->is_non_mobile;
    # docomo の 3G 端末では utf8 の表示が保障されている
    return 'utf-8' if $ma->is_docomo && $ma->xhtml_compliant;
    # softbank 3G の一部端末は cp932 だと絵文字を送ってこない不具合がある
    return 'utf-8' if $ma->is_softbank && $ma->is_type_3gc;
    # au は https のときに utf8 だと文字化ける場合がある
    return 'cp932';
}

sub run {
    my $self = shift;
    return $self->render('plugin/template/mobile');
}

no warnings 'redefine';

sub NanoA::mobile_agent {
    my $self = shift;
    NanoA::require_once('HTTP/MobileAgent.pm');
    $self->{stash}->{'HTTP::MobileAgent'} ||= HTTP::MobileAgent->new();
}

1;

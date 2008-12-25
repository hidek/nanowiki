package plugin::openid;

use strict;
use warnings;
use utf8;

use plugin::session;

use base qw(NanoA::Plugin);

sub _load_lib {
    NanoA::require_once('Net/OpenID/Consumer/Lite.pm');
}

sub init_plugin {
    my ($klass, $controller) = @_;
    plugin::session->init_plugin($controller);
    no strict 'refs';
    no warnings 'redefine';
    *{$controller . '::openid_login_uri'} = sub {
        my ($app, $op, $back_uri) = @_;
        if (defined $back_uri) {
            $back_uri = $app->nanoa_uri . '/' . $back_uri
                unless $back_uri =~ m{^(/|[a-z]+://)};
        } else {
            $back_uri = $app->nanoa_uri . ($app->query->path_info() || '');
            $back_uri .= '?' . $app->query->query_string if $app->query->query_string ;
        }
        _load_lib();
        Net::OpenID::Consumer::Lite->check_url(
            $op,
            $app->uri_for('plugin/openid', {
                back => $back_uri,
            }),
            {
                "http://openid.net/extensions/sreg/1.1" => {
                    required => 'email,nickname',
                },
            },
        );
    };
    *{$controller . '::openid_logout_uri'} = sub {
        my ($app, $back_uri) = @_;
        if (defined $back_uri) {
            $back_uri = $app->nanoa_uri . '/' . $back_uri
                unless $back_uri =~ m{^(/|[a-z]+://)};
        } else {
            $back_uri = $app->nanoa_uri . ($app->query->path_info() || '');
            $back_uri .= '?' . $app->query->query_string if $app->query->query_string ;
        }
        $app->uri_for('plugin/openid', {
            back => $back_uri,
            logout => 1,
        });
    };
    *{$controller . '::openid_user'} = sub {
        my $app = shift;
        $app->session->get('openid_user');
    };
    *{$controller . '::openid_logout'} = sub {
        my $app = shift;
        $app->session->remove('openid_user');
    };
}

sub run {
    my $app = shift;
    
    return $app->render('plugin/template/openid')
        unless $app->query->param;
    
    if ($app->query->param('logout')) {
        $app->session->remove('openid_user');
        if (my $back_uri = $app->query->param('back')) {
            $app->redirect($back_uri);
        }
        return "logged out";
    }
    
    _load_lib();
    
    # 本当はよくないことだけど、SSL の証明書があってなくてもスルーしちゃう。
    local $Net::OpenID::Consumer::Lite::IGNORE_SSL_ERROR = 1;
    
    my $query = $app->query;
    my $params = +{ map { $_ => $query->param($_) } $query->param };
    Net::OpenID::Consumer::Lite->handle_server_response(
        $params => (
            not_openid => sub {
                die "Not an OpenID message";
            },
            setup_required => sub {
                my $setup_url = shift;
                $app->redirect($setup_url);
            },
            cancelled => sub {
                return 'user cancelled';
            },
            verified => sub {
                my $vident = shift;
                $app->session->regenerate_session_id();
                $app->session->set(
                    'openid_user',
                    $vident,
                );
                if (my $back_uri = $app->query->param('back')) {
                    $app->redirect($back_uri);
                }
                "logged in";
            },
            error => sub {
                my $err = shift;
                die($err);
            },
        )
    );
}

1;

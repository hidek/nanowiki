package system::setup;

use strict;
use warnings;
use utf8;

use base qw(NanoA);

use plugin::form;

define_form(
    fields => [
        password  => {
            type       => 'password',
            label      => '管理用パスワード',
            # validation
            required   => 1,
            min_length => 8,
            max_length => 16,
        },
        password2 => {
            type       => 'password',
            label      => 'パスワード (確認)',
            # validation
            required   => 1,
            custom     => sub {
                my ($field, $query) = @_;
                if ($query->param('password') ne $query->param('password2')) {
                    return HTML::AutoForm::Error->CUSTOM(
                        $field,
                        'パスワードの値が一致しません。再入力してください',
                    );
                }
                return;
            },
        },
    ],
    submit_label => 'パスワードを設定',
);

sub run {
    my $app = shift;
    
    # do not allow resetting the password
    $app->redirect($app->uri_for('system/setup_complete'))
        if $app->config->prefs('system_password');
    
    if ($app->query->request_method eq 'POST' && $app->validate_form) {
        $app->config->prefs(
            'system_password',
            crypt($app->query->param('password'), '$1$' . $$ . rand() . time()),
        );
        $app->redirect($app->uri_for('system/setup_complete'));
    }
    
    $app->render('system/template/setup');
}

1;

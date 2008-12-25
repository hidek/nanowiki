package plugin::form;

use strict;
use warnings;
use utf8;

use HTML::AutoForm;

use base qw(NanoA::Plugin);

use plugin::session;

BEGIN {
    $HTML::AutoForm::CLASS_PREFIX = 'nanoa_form';
    $HTML::AutoForm::DEFAULT_LANG = 'ja';
};

sub init_plugin {
    my ($klass, $controller) = @_;
    plugin::session->init_plugin($controller);
    no strict 'refs';
    no warnings 'redefine';
    my $form;
    *{$controller . '::form'} = sub { $form };
    *{$controller . '::define_form'} = sub {
        $form = HTML::AutoForm->new(
            action => NanoA->nanoa_uri . '/' . NanoA::package_to_path($controller),
            @_ == 1 ? %{$_[0]} : @_,
        );
    };
    *{$controller . '::render_form'} = sub {
        die 'フォームが定義されていません。render_form の前に define_form を呼び出してください'
            unless $form;
        shift unless ref $_[0]; # klass->validate_form style
        my $app = shift;
        NanoA::raw_string(
            $form->render(
                $app->query,
                $app->session->session_id,
            ),
        );
    };
    *{$controller . '::validate_form'} = sub {
        die 'フォームが定義されていません。render_form の前に define_form を呼び出してください'
            unless $form;
        shift unless ref $_[0]; # klass->validate_form style
        my $app = shift;
        $form->validate(
            $app->query,
            sub {
                my $token = shift;
                $token eq $app->session->session_id;
            },
        );
    };
}

sub run {
    my $self = shift;
    return $self->render('plugin/template/form');
}

1;

package wiki::view;

use strict;
use warnings;
use utf8;

use base qw(NanoA);

use plugin::openid;
use wiki::plugin::wiki;

sub run {
    my $app   = shift;
    my $query = $app->query;

    my $name   = $query->param('name') || $app->redirect($app->uri_for('wiki/'));
   
    my $version = $query->param('version');
    my $page = $app->wiki_find_page($name, $version);

    unless ($page) {
        return $app->render( 'wiki/template/create', {name => $name}),
    }

    return $app->render(
        'wiki/template/view',
        {
            name    => $name,
            content => $app->wiki_format($page->{content}),
            page    => $page,
        }
    );
}

1;


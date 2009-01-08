package wiki::edit;

use strict;
use warnings;
use utf8;

use base qw(NanoA);

use plugin::openid;
use wiki::plugin::wiki;

sub run {
    my $app   = shift;
    my $query = $app->query;

    my $name    = $query->param('name');
    $app->redirect($app->uri_for('wiki')) unless $name;
    $app->redirect($app->uri_for('wiki/view', {name => $name})) unless $app->openid_user;
    
    my $version = $query->param('version');
    my $content = $query->param('content');
    my $author  = $query->param('author');

    my $preview;
    if ($query->request_method eq 'POST') {
        my $last_version = $app->wiki_get_last_version($name);

        if ($last_version >= $version + 1) {
            #xxx: conflict
        }

        if ($query->param('preview')) {
            $preview = $app->wiki_format($content);
        } else {
            $app->wiki_edit_page($name, $content, $author);
            $app->redirect($app->uri_for('wiki/view', {name => $name}));
        }
    } else {
        my $page = $app->wiki_find_page($name);
        $content = $page->{content} || '';
        $version = $page->{version} || 0;
        $author  = $app->openid_user->{'sreg.nickname'};
    }

    return $app->render(
        'wiki/template/edit',
        {   name    => $name,
            content => $content,
            author  => $author,
            version => $version,
            preview => $preview,
        }
    );
}

1;


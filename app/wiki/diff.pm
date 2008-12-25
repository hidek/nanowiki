package wiki::diff;

use strict;
use warnings;
use utf8;

use base qw(NanoA);
use plugin::openid;
use plugin::wiki;

use String::Diff;

sub run {
    my $app   = shift;
    my $query = $app->query;

    my $name   = $query->param('name') || $app->redirect($app->uri_for('wiki/'));
    my $origin = $query->param('origin');
    my $target = $query->param('target');

    my ($page_origin, $page_target);

    unless (defined $origin) {
        $page_origin = $app->wiki_find_page($name);
        $origin = $page_origin->{version};
    } else {
        $page_origin = $app->wiki_find_page($name, $origin);
    }

    $target = $origin - 1 unless defined $target;
    $page_target = $app->wiki_find_page($name, $target);

    my $content_origin = escape_html($page_origin->{content} || '');
    my $content_target = escape_html($page_target->{content} || '');
    $content_origin =~ s/\n/<br>/g;
    $content_target =~ s/\n/<br>/g;

    my $diff = String::Diff::diff_merge(
        $content_origin,
        $content_target,
        remove_open  => '<del>',
        remove_close => '</del>',
        append_open  => '<ins>',
        append_close => '</ins>',
    );

    return $app->render(
        'wiki/template/diff',
        {
            name   => $name,
            origin => $origin,
            target => $target,
            diff   => $diff
        }
    );
}

1;


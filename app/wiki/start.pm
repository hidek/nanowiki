package wiki::start;

use strict;
use warnings;
use utf8;

use base qw(NanoA);

use plugin::openid;
use wiki::plugin::wiki;

use Data::Page::Navigation;

sub run {
    my $app   = shift;
    my $query = $app->query;

    $app->db->do(
        qq{
        CREATE TABLE wiki (
        id integer not null primary key autoincrement,
        name varchar(255) not null,
        version integer not null,
        content text,
        openid varchar(255) not null,
        author varchar(255) not null,
        ipaddr varchar(255) not null,
        created_on datetime not null,
        UNIQUE (name, version)
        );
        },
    );

    my $page = $query->param('p') || 1;
    my $rows = 10;

    my $total = $app->wiki_count_pages;
    my $pager = Data::Page->new($total, $rows, $page);
    return $app->render(
        'wiki/template/start',
        {
            pages => $app->wiki_search_pages($page, $rows),
            pager => $pager
        },
    );
}

1;


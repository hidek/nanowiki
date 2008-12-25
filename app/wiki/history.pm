package wiki::history;

use strict;
use warnings;
use utf8;

use base qw(NanoA);
use plugin::openid;
use plugin::wiki;

sub run {
    my $app   = shift;
    my $query = $app->query;

    my $name = $query->param('name');
    
    return $app->render(
        'wiki/template/history',
        {   name => $name,
            versions => $app->wiki_search_versions($name),
        }
    );
}

1;


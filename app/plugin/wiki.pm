package plugin::wiki;

use strict;
use warnings;
use utf8;

use base qw(NanoA::Plugin);
use plugin::openid;

our $VERSION = '0.01';

{

    package Text::Hatena::Escaped;
    use base qw(Text::Hatena);

    sub text_line {
        my $class = shift;
        my $text  = shift->{items}->[2];
        return $class->escape("$text\n");
    }

    sub cdata {
        my $class = shift;
        my $items = shift->{items};
        my $data  = $items->[1];
        $data = $class->escape($data);
        return "<$data>\n";
    }

    sub pre_line {
        my $class   = shift;
        my $items   = shift->{items};
        my $inlines = $class->expand($items->[2]);
        return $class->escape("$inlines\n");
    }

    sub inline {
        my $class = shift;
        my $items = shift->{items};
        my $item  = $items->[0] or return;
        $item = $class->escape($item);
        $item = Text::Hatena::AutoLink->parse($item);
        return $item;
    }

    sub escape {
        my ($self, $text) = @_;
        return $text unless $text;
        for ($text) {
            s/&/&amp;/g;
            s/</&lt;/g;
            s/>/&gt;/g;
            s/"/&quot;/g;
        }
        $text;
    }

}

sub init_plugin {
    my ($klass, $controller) = @_;
    no strict 'refs';
    no warnings 'redefine';
    *{$controller . '::wiki_format'} = sub {
        my ($app, $raw) = @_;

        my $text = Text::Hatena::Escaped->parse($raw);
        return $text;
    };
    *{$controller . '::wiki_find_page'} = sub {
        my ($app, $name, $version) = @_;

        die 'wiki name is required' unless $name;

        my $where = 'WHERE name = ? ';
        $where .= 'AND version = ? ' if defined $version;
        my @params = ($name);
        push @params, $version if defined $version;
        my $sql
            = "SELECT * FROM wiki  $where ORDER BY version DESC LIMIT 0, 1;";

        return $app->db->selectrow_hashref($sql, undef, @params);
    };
    *{$controller . '::wiki_search_versions'} = sub {
        my ($app, $name, $page, $rows) = @_;

        die 'wiki name is required' unless $name;

        $page = 1 if !$page && $rows;
        my $sql = "SELECT * FROM wiki WHERE name = ? ORDER BY version DESC ";
        my @params = ($name);
        $sql .= "LIMIT ?, ?" if $page;
        push @params, ($rows * ($page - 1), $rows) if $page;

        return $app->db->selectall_arrayref($sql, {Slice => {}}, @params);
    };
    *{$controller . '::wiki_search_pages'} = sub {
        my ($app, $page, $rows) = @_;

        $page = 1 if !$page && $rows;
        my $sql = <<"SQL";
SELECT t1.* FROM wiki AS t1 
INNER JOIN (
    SELECT name, max(version) AS version 
    FROM wiki 
    GROUP BY name
) as t2
ON t1.name = t2.name AND t1.version = t2.version 
ORDER BY t1.created_on DESC
SQL
        my @params = ();
        $sql .= "LIMIT ?, ?" if $page;
        push @params, ($rows * ($page - 1), $rows) if $page;

        return $app->db->selectall_arrayref($sql, {Slice => {}}, @params);
    };
    *{$controller . '::wiki_edit_page'} = sub {
        my ($app, $name, $content, $author) = @_;

        die 'wiki name is required' unless $name;
        die 'author is required'    unless $author;

        my $sql = <<SQL;
INSERT INTO wiki (name, version, content, openid, author, ipaddr, created_on) 
VALUES (?, ?, ?, ?, ?, ?, datetime('now', 'localtime'));
SQL
        my $version = $app->wiki_get_last_version($name) + 1;
        $app->db->do($sql, undef, $name, $version, $content,
            $app->openid_user->{identity},
            $author, $app->query->remote_addr,);
    };
    *{$controller . '::wiki_delete_page'} = sub { };
    *{$controller . '::wiki_get_last_version'} = sub {
        my ($app, $name) = @_;

        die 'wiki name is required' unless $name;

        my $sql
            = 'SELECT max(version) as last_version FROM wiki WHERE name =?';

        return $app->db->selectrow_arrayref($sql, undef, $name)->[0] || 0;
    };
    *{$controller . '::wiki_count_pages'} = sub {
        my $app = shift;

        my $sql
            = 'SELECT count(*) as total FROM  (SELECT distinct name from wiki);';

        return $app->db->selectrow_arrayref($sql, undef)->[0] || 0;
    };
}

1;


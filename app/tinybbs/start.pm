package tinybbs::start;

use strict;
use warnings;
use utf8;

use plugin::form;
use plugin::mobile;
use plugin::openid;

use base qw(NanoA);

define_form(
    fields => [
        title => {
            type       => 'text',
            label      => 'タイトル',
            # validation
            required   => 1,
            max_length => 16,
        },
        body  => {
            type       => 'textarea',
            label      => 'メッセージ',
            # validation
            required   => 1,
        },
    ],
    submit_label => '投稿する',
);

sub run {
    my $app = shift;
    my $query = $app->query;
    
    # ignore errors, may exist
    $app->db->do(
        'create table bbs (id integer not null primary key autoincrement,title varchar(255),body text)',
    );

    if ($query->request_method eq 'POST' && $app->validate_form
            && $app->openid_user) {
        # insert
        $app->db->do(
            'insert into bbs (title,body) values (?,?)',
            {},
            $query->param('title'),
            $query->param('body'),
        );
        # redirect to myself
        $app->redirect;
    }
    
    return $app->render('tinybbs/template/start', {
        messages => $app->db->selectall_arrayref(
            'select id,title,body from bbs order by id desc',
            { Slice => {} },
        ),
    });
}

1;

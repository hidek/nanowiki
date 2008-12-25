<?= $app->render('plugin/template/header', { title => 'Form プラグイン' }) ?>

<h2>Form プラグイン</h2>

<div>
Form プラグインは、HTML::AutoForm を利用した HTML フォームの構築と検証機能を提供します。
</div>

<pre>
package myapp::start;

use strict;
use warnings;
use utf8;

<b>use plugin::form;</b>

use base qw(NanoA);

<b>define_form(
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
);</b>

sub run {
    my $app = shift;
    
    if ($query->request_method eq 'POST' && <b>$app->validate_form</b>) {
        # フォーム投稿を処理して、自分自身にリダイレクト
        ...
        $app->redirect;
    }
    
    # 情報を表示
}
</pre>
      
<?= $app->render('system/footer') ?>

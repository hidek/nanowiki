<?= $app->render('plugin/template/header', { title => 'OpenID プラグイン' }) ?>

<h2 id="session">OpenID プラグイン</h2>

<p>
OpenID プラグインを利用して、既知の RP Endpoint による認証を行うことができます。
</p>

<div class="pre_caption">ログイン済でなければ mixi のログインページへリダイレクト (.pm)</div>
<pre>
use plugin::openid;

sub run {
    ...
    my $user = $app->openid_user
        or $app->redirect($app->openid_login_uri('https://mixi.jp/openid_server.pl'));
    ...
</pre>

<?= $app->render('system/footer') ?>

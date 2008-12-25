<?= $app->render('system/header') ?>

<h2>サンプル掲示板</h2>

? if ($app->openid_user) {

<?= $app->render_form ?>
<a href="<?= $app->openid_logout_uri ?>">ログアウト</a>

? } else {

<h3>発言するにはログインが必要です (個人情報は記録／公開されません)</h3>

<ul>
<li><a href="<?= $app->openid_login_uri('https://mixi.jp/openid_server.pl') ?>">Mixi でログイン</a></li>
<li><a href="<?= $app->openid_login_uri('https://auth.livedoor.com/openid/server') ?>">Livedoor でログイン</a></li>
</ul>

? }

? for my $m (@{$c->{messages}}) {

<hr />
<h3><?= $m->{id} ?>. <?= $m->{title} ?></h3>
<?= $m->{body} ?>

? }

<hr />
<a href="http://coderepos.org/share/browser/lang/perl/NanoA/trunk/app/tinybbs">view source code</a>
<?= $app->render('system/footer') ?>

<?= $app->render('plugin/template/header', { title => 'Admin プラグイン' }) ?>

<h2>Admin プラグイン</h2>

<p>
Admin プラグインを利用して、管理者権限でのログイン状態を制御することができます。
</p>

<div class="pre_caption">管理者としてログイン済でなければログインページへリダイレクト (.pm)</div>
<pre>
use plugin::admin;

# このページの操作には管理者権限が必要
sub run {
    ...
    $app->redirect($app->admin_login_uri)
        unless $app->is_admin;
    ...
</pre>

<h2>現在のログイン状態</h2>

<div>
? if ($app->is_admin) {
管理者としてログイン中です。<input type="button" onclick="location='<?= $app->uri_for('plugin/admin', { mode => 'logout', back => $app->uri_for('plugin/admin') }) ?>'" value="ログアウト">
? } else {
管理者としてログインしていません。<input type="button" onclick="location='<?= $app->uri_for('plugin/admin', { mode => 'login', back => $app->uri_for('plugin/admin') }) ?>'" value="ログイン">
? }
</div>

<?= $app->render('system/footer') ?>

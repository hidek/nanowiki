<?= $app->render('system/header', { title_suffix => 'プラグイン' }) ?>

<h2>プラグインについて</h2>

<p>
NanoA の動作を、プラグインを使って拡張することができます。プラグインは、各コントローラ (.pm ファイルまたは .mt ファイル) で use pluginname; するだけで適用されます。
</p>

<div class="pre_caption">例. セッションプラグインの適用 (.pm)</div>
<pre>
use plugin::session;
</pre>

<div class="pre_caption">例. セッションプラグインの適用 (.mt)</div>
<pre>
&#x3f; use plugin::session;
</pre>

<p>
また、myapp/config.pm 内で use pluginname; すれば、同ディレクトリ内の全コントローラにプラグインが適用されます。例えば、全コントローラでモバイル対応機能を有効化したい、という場合は、こちらの手法が便利です。
</p>

<h2>インストール済のプラグイン</h2>

<ul>

? for my $p (<app/plugin/*.pm>) {
?   $p =~ s|^app/plugin/(.*)\.pm$|$1|;
<li><a href="<?= $p ?>"><?= $p ?></li>
? }

</ul>

<?= $app->render('system/footer') ?>

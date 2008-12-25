<?= $app->render('plugin/template/header', { title => 'Session プラグイン' }) ?>

<h2 id="session">Session プラグイン</h2>

<p>
セッションプラグインをロードすると、自動的にセッションクッキーが発行されるようになります。また、$app->session() 関数を呼んで HTTP::Session オブジェクトを取得し、認証処理等を実現可能です。 
</p>

<div class="pre_caption">セッション機能の有効化 (.pm)</div>
<pre>
use plugin::session;
</pre>

<p>
<div class="pre_caption">セッション機能の有効化 (.mt)</div>
<pre>
&#x3f; use plugin::session;
</pre>

</p>

<div class="pre_caption">セッションオブジェクトの取得</div>
<pre>
my $session = $app->session;
</pre>

<?= $app->render('system/footer') ?>

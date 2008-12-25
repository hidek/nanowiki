<?= $app->render('plugin/template/header', { title => 'Counter プラグイン' }) ?>

<h2 id="session">Counter プラグイン</h2>

<p>
ページにアクセスカウンタをつけるプラグインです。テンプレートの中からカウンタを呼び出すだけで、ヒット数が表示されます。
</p>

<div class="pre_caption">カウンタをつける (.mt)</div>
<pre>
...
&lt;?= $app->render('plugin/counter') ?&gt;
...
</pre>

<p>
カウンタに名前をつけて、複数のコントローラで値を共有することも可能です。
</p>

<div class="pre_caption">指定した名前のカウンタをつける (.mt)</div>
<pre>
&lt;&= $app->render('plugin/counter', { name => 'MyApp_counter' }) ?&gt;
</pre>

<?= $app->render('system/footer') ?>

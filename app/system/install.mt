<?= $app->render('system/header', { title_suffix => 'インストール' }) ?>

<h2>共有サーバへのインストール</h2>
<p>
一般的な <a href="http://httpd.apache.org/docs/2.0/ja/suexec.html">suEXEC</a> 対応の共用サーバには、以下の手順でインストールできます。
</p>
<ol>
<li>共用サーバに、ウェブ閲覧可能な新しいディレクトリを作成</li>
<li><a href="http://kazuho.31tools.com/nanoa/dist/">kazuho.31tools.com/nanoa/dist</a> から、最新の nph-nanoa-X.XX-installer.cgi をダウンロードして、手順 1 のディレクトリにアップロード</li>
<li>ウェブブラウザで手順 1 で作成したディレクトリを開いて、アップロードしたファイルをクリック</li>
<li>自動的にパッケージが展開され、NanoA の起動画面へ遷移します</li>
</ol>

<h2>開発版のダウンロード</h2>
<p>
Subversion を使用して、<a href="http://svn.coderepos.org/share/lang/perl/NanoA/trunk/">svn.coderepos.org/share/lang/perl/NanoA/trunk</a> からソースコードをダウンロードします。ダウンロードしたディレクトリを HTTP アクセス可能なディレクトリに移動すれば、動作を開始します。
</p>
<p>
以下の例では、http://host/~user/nanoa/ というディレクトリが、NanoA のインストール先になります。
</p>
<pre>
% svn co http://svn.coderepos.org/share/lang/perl/NanoA/trunk
% mv trunk ~/public_html/nanoa
</pre>

<?= $app->render('system/footer') ?>

<?= $app->render('system/header') ?>
<h2>NanoA ってなに?</h2>
<div>
NanoA は、気軽に使えるウェブアプリケーション実行環境です。その特徴は以下のとおり。
<ul>
<li>初心者でも簡単にアプリケーションを作成可能</li>
<li>モダンな Perl のオブジェクト指向フレームワーク</li>
<li>レンタルサーバに最適 (suEXEC 環境で設定不要、CGI として高速に動作)</li>
<li>アプリケーションの管理／設定機能が最初から存在するので開発不要 (予定)</li>
<li><a href="<?= $app->uri_for('plugin/') ?>">プラグイン</a>によるフォーム生成／バリデータや OpenID、ケータイ対応</li>
</ul>
CGI で使えるウェブアプリケーションフレームワーク、ではなく、ウェブアプリケーションの開発／保守を簡単にする実行環境、を目指しています。
</div>

<h2>インストール済のアプリケーション</h2>

<div>
現在、以下のアプリケーションが実行可能です。
<ul>
? foreach my $dir (<app/*/start.*>) {
?   next if $dir =~ /~$/;
?   $dir =~ s|app/(.*)/[^/]+$|$1|;
<li><a href="<?= $app->nanoa_uri . "/$dir/" ?>"><?= $dir ?></a></li>
? }
</ul>
</div>

<?= $app->render('system/footer') ?>

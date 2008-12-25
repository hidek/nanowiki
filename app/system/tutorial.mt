? use plugin::mobile;
<?= $app->render('system/header', { title_suffix => 'チュートリアル' }) ?>

<h2 id="install">インストール</h2>
<p>
まず、<a href="install">インストール</a>の説明に従って、NanoA をインストールします。インストールが完了すると、<a href="<?= $app->nanoa_uri ?>">こちら</a>の画面が表示されるようになります。
</p>

<h2 id="helloworld">Helloworld の作成</h2>
<p>
app/hello というディレクトリを作成し、以下のようなファイル (start.mt) を置きます。
</p>
<div class="pre_caption">app/hello/start.mt</div>
<pre>
こんにちは、&lt;?= $app->query->param('user') ?&gt;さん
</pre>
<p>
続いて、NanoA のトップページをリロードしてみましょう。hello というアプリケーションが増えているはずです (今あなたが書いたアプリケーションです) 。そのアプリケーション名をクリックすると、「こんにちは、さん」と表示されます。
</p>
<p>
nanoa.cgi/hello/?user=太郎 という URL にアクセスすると、「こんにちは、太郎さん」と表示されます。
</p>
<div class="column">
<h3>クエリパーサについて</h3>
<p>
NanoA は、クエリパーサとして <a href="http://search.cpan.org/dist/CGI-Simple/">CGI::Simple</a> を同梱しています。上記の $app->query は、クエリオブジェクトを取得する処理です。リクエストのパースやファイルアップロードの受信、クッキー処理の手法については、CGI::Simple のドキュメントをご参照ください。
</p>
</div>
<div class="column">
<h3>テンプレートエンジンについて</h3>
<p>
NanoA ではテンプレートエンジンに、Mojo::Template をベースにした MENTA::Template を採用し、PHP ライクな記法でテンプレートを書くことができます。文字列は自動でエスケープされるので、XSS 脆弱性を気にすることなく開発を進めることができます。
<div class="table">
<table>
<caption>表. テンプレートの代表的な使い方</caption>
<tr>
<th>記法</th>
<th>意味</th>
</tr>
<tr>
<td>&lt;?= $hoge ?&gt;</td>
<td>$hoge を HTML エスケープして出力</td>
</tr>
<tr>
<td>&lt;?=r $hoge ?&gt;</td>
<td>$hoge をエスケープせずに出力</td>
</tr>
<tr>
<td>&lt;?= $app->render('hello/header') ?&gt;</td>
<td>app/hello/header.mt をインクルード</td>
</tr>
<tr>
<td>? for my $row (@rows) {<br />&lt;?= $row->{name} ?&gt;<br />? }</td>
<td>リストを表示</td>
</table>
</div>
</p>
</div>

<h2 id="split_template">テンプレートの分離</h2>

<p>
コードの見通しを良くするために、テンプレートとコントローラのロジックを分離して書くこともできます。Helloworld を分離して書き直すと、以下のようになります。極めて正統的な Perl です。
</p>

<div class="pre_caption">app/hello/start.pm</div>
<pre>
package hello::start;

use strict;
use warnings;
use utf8;

use base qw(NanoA);

sub run {
    my $app = shift;
    return $app->render('hello/template/start', {
        user => $app->query->param('user'),
    });
}

1;
</pre>

<div class="pre_caption">app/hello/template/start.mt</div>
<pre>
こんにちは、&lt;?= $c->{user} ?&gt;さん
</pre>

<div class="column">
<h3>.pm ファイルと .mt ファイルについて</h3>
<p>
NanoA では、perl ソースコードに .pm 拡張子を、テンプレートに .mt 拡張子を使用するようになっています。NanoA のディスパッチャは、.mt と .pm ファイルを検索し、自動的に実行します。また、$app->render(filename) という呼出を行うことで、.pm の中で .mt ファイルをレンダリングしたり、逆に .mt ファイルの中から .pm ファイルを実行したりすることが可能です。
</p>
</div>

<h2 id="database">データベース接続</h2>

<p>
NanoA は標準で SQLite データベースへの接続機能を提供します。NanoA セットアップ時に自動的にデータベースが生成されるので、アプリケーションの中では、$app->db にアクセスするだけで、データベースハンドルを取得することができます。
</p>

<div class="pre_caption">データベース使用例</div>
<pre>
# ユーザーテーブルを (なければ) 作成
$app->db->do(
    'create table if not exists user ('
    . 'user_id integer not null primary key autoincrement,'
    . 'user_name text not null'
    . )'
);
...
# ユーザーテーブルに行を追加
$app->db->do(
    'insert into user (user_name) values (?)',
    {},
    $app->query->name('user_name'),
);
...
# ユーザーテーブルからクエリした結果をテンプレートに渡す
$app->render('myapp/template/mytemplate', {
    all_users => $app->db->selectall_arrayref(
        'select user_id,user_name from user',
        { Slice => {} },
    ),
});
</pre>

<div class="column">
<h3>データベースハンドルについて</h3>
<p>
NanoA のデータベースハンドルは、Perl 標準のデータベースインターフェイスである <a href="http://search.cpan.org/~timb/DBI/DBI.pm">DBI</a> です。
</p>
</div>

<h2 id="config">アプリケーションの設定</h2>

<h2 id="hooks">アプリケーション全体の共通処理</h2>

<h2 id="plugin">プラグイン機構</h2>

<p>
NanoA の動作は、プラグインを使って拡張可能です。詳しくは、<a href="../plugin/">プラグインの説明ページ</a>をご覧ください。
</p>

<?= $app->render('system/footer') ?>

? use plugin::mobile;
<?= $app->render('plugin/template/header', { title => 'Mobile プラグイン' }) ?>

<h2 id="session">Mobile プラグイン</h2>

<p>
モバイルプラグインをロードすると、携帯端末にあわせて自動的に文字コードを変換して送受信するようになります。
</p>

<div class="pre_caption">start.pm (モバイル対応)</div>
<pre>
package hello::start;

use strict;
use warnings;
use utf8;

<b>use plugin::mobile;</b>

use base qw(NanoA);

sub run {
    my $app = shift;
    return $app->render('hello/template/start', {
        user => $app->query->param('user'),
    });
}

1;
</pre>

<div class="pre_caption">start.mt (モバイル対応)</div>
<pre>
<b>&#x3f; use plugin::mobile;</b>
こんにちは、&lt;?= $app->query->param('user') ?&gt;さん
</pre>

<p>
また、<a href="http://search.cpan.org/~kurihara/HTTP-MobileAgent/lib/HTTP/MobileAgent.pm">HTTP:MobileAgent</a> を利用して、キャリアを判定したり、端末固有番号を取得することが可能です。
</p>
<pre>
sub run {
    my $app = shift;
    ...
    my $carrier = $app->mobile_agent->carrier_longname;
    return "あなたのブラウザは $carrier です";
}
</pre>
<p style="text-align: center;">
実行例: 「あなたのブラウザは <?= $app->mobile_agent->carrier_longname ?> です」
</p>

<?= $app->render('system/footer') ?>

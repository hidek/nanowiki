<?= $app->render('example/template/header') ?>
<p>
This is NanoA exmaple application.  Thank you for installing.
</p>
<hr />
<p>
There are two ways to write applications using NanoA.
</p>
<ul>
<li><a href="http://coderepos.org/share/browser/lang/perl/NanoA/trunk/app/example/start.pm">source code of this page</a> (logic &amp; template style)</li>
<li><a href="http://coderepos.org/share/browser/lang/perl/NanoA/trunk/app/example/mojo.mt">PHP style source code</a> (can be executed directly: <a href="mojo?user=john">link</a>)</li>
</ul>
<p>
Now comes with a shocking debug screen as well: <a href="debugscreen">see debug screen</a>.
</p>
<hr />
<p>
And finally, best wishes to you from <a href="http://labs.cybozu.co.jp/blog/kazuho/">Kazuho Oku</a>, developer of NanoA.
</p>
<?= $app->render('example/template/footer') ?>

<?= $app->render('wiki/template/header', {name => $c->{name}}) ?>

<h3 id="name"><?= $c->{name} ?></h3>

? if ($c->{preview}) {
<div id="content">
<?= raw_string($c->{preview}) ?>
</div>
? }

<!--
<a href="http://daringfireball.net/projects/markdown/syntax.php" target="_blank">Markdown syntax</a>
-->
<a href="http://hatenadiary.g.hatena.ne.jp/keyword/%E3%81%AF%E3%81%A6%E3%81%AA%E8%A8%98%E6%B3%95%E4%B8%80%E8%A6%A7" target="_blank">Hatena syntax</a>

<form method="post">
<textarea id="input_content" name="content"><?= $c->{content} ?></textarea>

<p>
<label for="input_content">Author:</label>
<input type="text" name="author" value="<?= $c->{author} ?>" size="40"/>
</p>

<p>
<input type="hidden" name="name" value="<?= $c->{name} ?>"/>
<input type="hidden" name="version" value="<?= $c->{version} ?>" />
<input type="submit" name="post" value="post"/> 
<input type="submit" name="preview" value="preview"/> or 
<a href="<?= $app->uri_for('wiki/view', {name => $c->{name}}) ?>">Cancel</a>
</p>

</form>

<?= $app->render('wiki/template/footer') ?>


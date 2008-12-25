<?= $app->render('wiki/template/header', {name => $c->{name}}) ?>

? if ($c->{preview}) {
<div id="content">
<?= raw_string($c->{preview}) ?>
</div>
? }

<h3 id="name"><?= $c->{name} ?></h3>

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


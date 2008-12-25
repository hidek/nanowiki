<?= $app->render('wiki/template/header', {name => $c->{name}}) ?>

<form action="<?= $app->uri_for('wiki/diff') ?>" method="post">
<table id="versions">
<tr>
<th colspan="2">compare</th>
<th>version</th>
<th>author</th>
<th>date</th>
</tr>
? for my $page (@{$c->{versions}}) {
<tr>
<td><input type="radio" name="origin" value="<?= $page->{version} ?>" /></td>
<td><input type="radio" name="target" value="<?= $page->{version} ?>" /></td>
<td><?= $page->{version} ?></td>
<td><?= $page->{author} ?></td>
<td><?= $page->{created_on} ?></td>
</tr>
? }
</table>
<input type="hidden" name="name" value="<?= $c->{name} ?>"/>
<input type="submit" value="Compare" />
</form>

<?= $app->render('wiki/template/footer') ?>


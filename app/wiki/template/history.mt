<?= $app->render('wiki/template/header', {name => $c->{name}}) ?>

<form action="<?= $app->uri_for('wiki/diff') ?>" method="post">

<table id="versions">
<tr>
<th colspan="2">compare</th>
<th>ver</th>
<th>author</th>
<th>date</th>
</tr>
? for my $page (@{$c->{versions}}) {
<tr>
<td class="td-compare"><input type="radio" name="origin" value="<?= $page->{version} ?>" /></td>
<td class="td-compare"><input type="radio" name="target" value="<?= $page->{version} ?>" /></td>
<td class="td-version"><?= $page->{version} ?></td>
<td class="td-author"><?= $page->{author} ?></td>
<td class="td-date"><?= $page->{created_on} ?></td>
</tr>
? }
</table>

<input type="hidden" name="name" value="<?= $c->{name} ?>"/>
<input type="submit" value="Compare" />
</form>

<?= $app->render('wiki/template/footer') ?>


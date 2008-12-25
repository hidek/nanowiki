<?= $app->render('wiki/template/header', {name => $c->{name}}) ?>
<h3><?= $c->{name} ?> is not found.</h3>
? if ($app->openid_user) {
<form method="get" action="<?= $app->uri_for('wiki/edit') ?>">
Create new page?
<input type="hidden" name="name" value="<?= $c->{name} ?>"/>
<input type="submit" value="create" />
</form>
? }
<?= $app->render('wiki/template/footer') ?>

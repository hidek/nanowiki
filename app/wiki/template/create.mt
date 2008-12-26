? if ($app->openid_user) {
<hr />
<form id="form-create" action="<?= $app->uri_for('wiki/edit') ?>" method="get">
Create new page: <input type="text" name="name" />
<input type="submit" value="create" />
</form>
? }


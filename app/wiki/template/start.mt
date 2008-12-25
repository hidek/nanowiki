<?= $app->render('wiki/template/header', {name => $c->{name}}) ?>
<table>
<tr>
<th>name</th>
<th>author</th>
<th>created on</th>
</tr>
? for my $page (@{$c->{pages}}) {
<tr>
<td><a href="<?= $app->uri_for('wiki/view', {name => $page->{name}}) ?>"><?= $page->{name} ?></a></td>
<td><?= $page->{author} ?></td>
<td><?= $page->{created_on} ?></td>
</tr>
? }
</table>

<div class="page-stats">
Results <?= $c->{pager}->first ?> - <?= $c->{pager}->first ?> of <?= $c->{pager}->total_entries ?>
</div>

<div class="page-navi">
<a href="<?= $app->uri_for('wiki/', {page => $c->{pager}->first_page}) ?>">&laquo; First</a>

? if ($c->{pager}->previous_page) {
<a href="<?= $app->uri_for('wiki/', {page => $c->{pager}->previous_page}) ?>">&lsaquo; Prev</a>
? } else {
&lsaquo; Prev
? }

? for my $page ($c->{pager}->pages_in_navigation) {
? if ($page == $c->{pager}->current_page) {
<?= $page ?>&nbsp
? } else  {
<a href="<?= $app->uri_for('wiki/', {page => $page}) ?>"><?= $page ?>&nbsp</a>
? }
? }

? if ($c->{pager}->next_page) {
<a href="<?= $app->uri_for('wiki/', {page => $c->{pager}->next_page}) ?>">Next &rsaquo;</a>
? } else {
Next &rsaquo;
? }

<a href="<?= $app->uri_for('wiki/', {page => $c->{pager}->last_page}) ?>">Last &raquo;</a>
</div>


? if ($app->openid_user) {
<form action="<?= $app->uri_for('wiki/edit') ?>" method="get">
Create new page: <input type="text" name="name" />
<input type="submit" value="create" />
</form>
? }
<?= $app->render('wiki/template/footer') ?>


<?= $app->render('wiki/template/header' , {name => $c->{name}}) ?>

<p> Diff: ver.<?= $c->{origin} ?> - ver.<?= $c->{target} ?> </p>

<div id="diff">
<?=r $c->{diff} ?>
</div>

<?= $app->render('wiki/template/footer') ?>

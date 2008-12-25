<?= $app->render('wiki/template/header', {name => $c->{name}}) ?>

<div id="content"><?=r $c->{content} ?></div>

<?= $app->render('wiki/template/footer') ?>


<?= $app->render('wiki/template/header', {name => $c->{name}}) ?>

<div id="content"><?= raw_string($c->{content}) ?></div>

<?= $app->render('wiki/template/footer') ?>


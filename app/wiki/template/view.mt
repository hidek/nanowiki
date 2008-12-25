<?= $app->render('wiki/template/header', {name => $c->{name}}) ?>

<h3 id="name"><?= $c->{name} ?></h3>

<div id="content"><?= raw_string($c->{content}) ?></div>

<?= $app->render('wiki/template/footer') ?>


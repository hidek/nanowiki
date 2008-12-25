<?= $app->render('example/template/header') ?>
Hello to <?= $app->query->param('user') || '' ?>.
<?= $app->render('example/template/footer') ?>

? my $pi = $app->query->path_info;
? return $app->render('system/app_list') unless $pi;
<? $app->header(-status => 404); ?>
<?= $app->render('system/header') ?>
<h2>File Not Found</h2>
File Not Found.  The list of installed applications can be found: <a href="<?= $app->nanoa_uri ?>">here</a>.
<?= $app->render('system/footer') ?>

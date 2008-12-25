<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" href="<?= $app->root_uri() ?>/app/system/style.css" type="text/css" />
<link rel="stylesheet" href="<?= $app->root_uri() ?>/app/system/nanoa_form.css" type="text/css" />
<title>NanoA<?= $c->{title_suffix} ? " :: $c->{title_suffix}" : "" ?></title>
</head>
<body>
<center>
<div id="body">
<div id="top">
<ul id="links">
<li><a href="<?= $app->nanoa_uri() ?>">トップ</a></li>
<li><a href="<?= $app->nanoa_uri() ?>/system/install">インストール</a></li>
<li><a href="<?= $app->nanoa_uri() ?>/system/tutorial">チュートリアル</a></li>
<li><a href="<?= $app->nanoa_uri() ?>/plugin/">プラグイン</a></li>
</ul>
<h1><a href="<?= $app->nanoa_uri() ?>">NanoA</a></h1>
</div>
<div id="breadcrumb">
? if ($c->{breadcrumb}) {
?   for (my $i = 0; $i < @{$c->{breadcrumb}}; $i += 2) {
?     if ($i != 0) {
&gt;
?     }
?     my $title = $c->{breadcrumb}->[$i];
?     if (my $link = $c->{breadcrumb}->[$i + 1]) {
<a href="<?= $link ?>"><?= $title ?></a>
?     } else {
<?= $title ?>
?     }
?   }
? }
</div>
<div id="main">

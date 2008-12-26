<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" href="<?= $app->root_uri . '/app/wiki/styles/reset-fonts.css' ?>" type="text/css" />
<link rel="stylesheet" href="<?= $app->root_uri . '/app/wiki/styles/base-min.css' ?>" type="text/css" />
<link rel="stylesheet" href="<?= $app->root_uri . '/app/wiki/styles/prettify.css' ?>" type="text/css" />
<link rel="stylesheet" href="<?= $app->root_uri . '/app/wiki/styles/style.css' ?>" type="text/css" />
<script type="text/javascript" src="<?= $app->root_uri . '/app/wiki/scripts/jquery-1.2.6.min.js' ?>"></script>
<script type="text/javascript" src="<?= $app->root_uri . '/app/wiki/scripts/prettify.js' ?>"></script>
<script type="text/javascript" src="<?= $app->root_uri . '/app/wiki/scripts/script.js' ?>"></script>
<title>NanoWiki<?= $c->{name} ? ' - ' . $c->{name} : '' ?></title>
</head>
<body>
<div id="container">
<div id="header"><a href="<?= $app->uri_for('wiki/') ?>">NanoWiki</a></div>
<div id="login">
? if ($app->openid_user) {
<a href="<?= $app->openid_logout_uri ?>">[Sign out]</a>
? } else {
<a href="<?= $app->openid_login_uri('https://mixi.jp/openid_server.pl') ?>">[Sign in w/ Mixi account]</a>
? }
</div>

? if (ref $app ne 'wiki::start') {
<div id="navi">
<ul>
<li> | <a href="<?= $app->uri_for('wiki/view',    {name => $c->{name}}) ?>">Last version</a></li>
<li> | <a href="<?= $app->uri_for('wiki/history', {name => $c->{name}}) ?>">History</a></li>
? if ($app->openid_user) {
<li> | <a href="<?= $app->uri_for('wiki/edit', {name => $c->{name}}) ?>">Edit</a></li>
? } else {
<li> | Edit</li>
? }
</ul>
</div>
? }

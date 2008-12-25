#! /usr/bin/env perl

use strict;
use warnings;

use lib qw(lib MENTA/lib MENTA/extlib);
use lib <extlib/*>;

use CGI::ExceptionManager;
use Class::Accessor::Lite;
use NanoA;
use NanoA::Config;
use NanoA::Dispatch;
use NanoA::TemplateLoader;

require 'nanoa.pl';

1;

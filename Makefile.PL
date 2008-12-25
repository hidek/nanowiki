# NOTES:
#   このファイル、およびlibはあくまで開発者向けのもので、ユーザーには
#       nanoa.cgi
#       system/not_found.mt
#       system/app_list.mt
#       system/header.mt
#       system/footer.mt
#   の4ファイルのみを提供する。
#
#   nanoa.cgiはmake nanoaで作成される

use strict;
use inc::Module::Install;
use File::Find::Rule; # ここで使うだけだから許して！
use File::Spec;

name('NanoA');
all_from('lib/NanoA.pm');

# requires には Perl 5.8にデフォルトでインストールされているもの以外は
# 使ってはいけません

# ここでnanoaルールを定義
my @extra_files = qw(
    .htaccess
);

my $version = version();
my $distdir = File::Spec->catfile('dist-cgi', $version);
my $postamble = <<EOM;
NANOADIR = $distdir
NANOAVER = $version

EOM

$postamble .= <<'EOM';

NANOA_CGI_FILES = MENTA/extlib/Class/Accessor/Lite.pm MENTA/extlib/CGI/ExceptionManager.pm lib/NanoA/Config.pm lib/NanoA/Dispatch.pm lib/NanoA/Plugin.pm lib/NanoA/TemplateLoader.pm lib/NanoA.pm nanoa.pl

nanoadir: 
	$(NOECHO)$(RM_RF) $(NANOADIR);
	$(NOECHO)$(MKPATH) $(NANOADIR);

nanoacgi: $(NANOA_CGI_FILES)
	$(FULLPERLRUN) tools/concat.pl -s -n strict,warnings $(NANOA_CGI_FILES) > $(NANOADIR)/nanoa.cgi
	$(NOECHO)$(CHMOD) 755 $(NANOADIR)/nanoa.cgi
	$(NOECHO)$(ECHO) "Generated $(NANOADIR)/nanoa.cgi"

nanoamanifest:
	$(NOECHO)$(FULLPERLRUN) tools/manifest.pl $(NANOADIR) > $(NANOADIR)/MANIFEST

nanoaapp:
	$(NOECHO)$(MKPATH) $(NANOADIR)/app
	(cd app && tar cf - --no-recursion `svn ls -R`) | (cd $(NANOADIR)/app && tar xf -)

nanoa-dist: nanoa
EOM

$postamble .= <<'EOM';
	$(NOECHO)(cd $(NANOADIR) && tar czf ../nanoa-$(NANOAVER).tar.gz .)
	tgz2cgi/tgz2cgi.pl --title='NanoA Installer' --end='<a href="./">Next step</a><script>window.setTimeout(function () { location = "./"; }, 5000)</script>' --check-files=.htaccess,nanoa.cgi,lib,extlib,var,app --nph < dist-cgi/nanoa-$(NANOAVER).tar.gz > dist-cgi/nph-nanoa-$(NANOAVER)-installer.cgi
	$(NOECHO)chmod 755 dist-cgi/nph-nanoa-$(NANOAVER)-installer.cgi
EOM

$postamble .= <<'EOM';
	$(NOECHO)rm -r $(NANOADIR)


nanoa: nanoadir nanoacgi nanoaextlib nanoaapp nanoamanifest
	$(NOECHO)$(NOOP)

nanoaextlib: 
	$(NOECHO)$(MKPATH) $(NANOADIR)/extlib
	(cd MENTA/extlib && tar cf - --exclude .svn .) | (cd $(NANOADIR)/extlib && tar xf -)
	(cd extlib && tar cf - --exclude .svn .) | (cd $(NANOADIR)/extlib && tar xf -)
	(cd MENTA/extlib && ../../tools/concat.pl -n strict,warnings,Class::Accessor::Lite `find HTML/AutoForm* -name '*.pm' | sort`) > $(NANOADIR)/extlib/HTML/AutoForm.pm
	(cd MENTA/lib && tar cf - MENTA/Template.pm) | (cd $(NANOADIR)/extlib && tar xf -)

EOM

foreach my $file (@extra_files) {
    $postamble .= <<"EOM";
	\$(CP) $file \$(NANOADIR)/$file
EOM
}

postamble($postamble);

WriteAll;

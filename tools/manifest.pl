use strict;
use 5.008;
use Digest::MD5;
use File::Find::Rule;

my @files = File::Find::Rule->file()->relative()->in($ARGV[0]);
foreach my $file (@files) {
    next if $file eq 'MANIFEST';
    open(my $fh, '<', "$ARGV[0]/$file") or die "cannot open $ARGV[0]/$file:$!:";
    print $file, " ", Digest::MD5->new->addfile($fh)->hexdigest, "\n";
}

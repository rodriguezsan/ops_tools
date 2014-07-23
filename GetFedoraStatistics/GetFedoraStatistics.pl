#!/usr/bin/perl 

=head1 NAME

GetFedoraStas.pl

=head1 SYNOPSIS

B<GetFedoraStats.pl>

=head1 DESCRIPTION

B<.pl>
Utility for getting statistics for Fedora.

=head1 OPTIONS

=item B<-n> I<namespace>

Checks fedora depending on namespaces

=back

=head1 REQUIRES

Getopt::Std, Pod::Usage

=cut

use File::Find;
use Getopt::Std;
use Pod::Usage;
#use warnings;

my $Opts;

if (@ARGV > 2) {
    pod2usage(  MSG=>'ERROR: too many arguments.' , VERBOSE=>1);
 } elsif (@ARGV < 2) {
    pod2usage(  MSG=>'ERROR: too few arguments.' , VERBOSE=>1);
 } else {
    ParseArgs();
 }

my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=localtime(time);
my $datestamp = sprintf("%4d%02d%02d", $year+1900, $mon+1, $mday);

my $Counter = "0";
my $CounterAll = "0";
my $FileSizeTotal = "0";

my $rootDir = "/mnt/storage/fedora/data/datastreamStore";

## begin main routine 

find (\&printFile, $rootDir);

print "\n----------------------------------------------------------\n";
print "Namespace: $Opts{n} returns $Counter/$CounterAll OBJ files\n\n";
print $FileSizeTotal ." B\n";
print $FileSizeTotal/1024 ." kB\n";
print $FileSizeTotal/1024/1024 ." MB\n";
print $FileSizeTotal/1024/1024/1024 ." GB\n";

## begin subroutines

sub printFile {

  my $FileName = $_;
  my $FilePath = $File::Find::name;
  my $NameSpace = "info%3Afedora%2F" . $Opts{n};

  if ($Opts{n} ne "") {

    if ($FileName =~ $NameSpace && $FileName =~ "OBJ") {

      my $FileSize = -s "$FilePath";

      $FileSizeTotal = $FileSizeTotal + $FileSize;
      print "$FileSize $FileSizeTotal $FileName\n";

      $Counter++;

    }

    $CounterAll++;

  } else {
    pod2usage(VERBOSE=>1);
  }
}

sub ParseArgs {
    getopts('h:n:', \%Opts);
    $Opts{h} and pod2usage(VERBOSE=>1);
}

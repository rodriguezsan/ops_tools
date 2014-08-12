#!/usr/bin/perl

=head1 NAME

BreakXml.pl

=head1 SYNOPSIS

B<BreakXml.pl>

=head1 DESCRIPTION

B<.pl>
Utility for breaking up a big xml metadata file into smaller ones.

=head1 OPTIONS

=item B<-n> I<namespace>

Checks fedora depending on namespaces

=back

=head1 REQUIRES

File::Find, Getopt::Std, Pod::Usage, XML::Twig

=cut

#use File::Find;
#use Getopt::Std;
use Pod::Usage;
use XML::Twig

my $FileName = undef;
my $DirName = undef;

$FileName = "output-filetosplit.xml";
$FileName =~ m/(.*)\.xml/;
$DirName = $1;

print $FileName . "\t" . $DirName . "\n";

if (-e $FileName) {

  if (-d $DirName) {
    rmdir $DirName || die "Couldn't rm $DirName: $!";
  } else {
    mkdir $DirName || die "Couldn't mk $DirName: $!";
  }

  
  
} else {
  die "File does not exist: $!";
}


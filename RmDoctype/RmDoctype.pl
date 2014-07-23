#!/usr/bin/perl
use File::Find;

my $counter = "0";
my $counter_all = "0";

my $rootDir = "/mnt/storage/fedora/data/datastreamStore";
#my $rootDir = "/home/redmonp/scripts/islandora/rmDoctype";

## Main Routine ##

find (\&printFile, $rootDir);

## Subroutines ##

sub printFile {

  my $file = $_;
  my $full_file = $File::Find::name;

  if (-d $file && $file !~ /.{1,2}/) {

    print "dir: $file\n";

  } else {

    if ($full_file =~ "HOCR") {
#    if ($full_file =~ "zzz") {

      open (IN, "<$full_file") || die "$!";

      while (<IN>) {

        if ($_ =~ m/DOCTYPE html PUBLIC/) {

          print "$counter of $counter_all\tMATCH: $full_file\n";

          print "sed -i /DOCTYPE html PUBLIC/d $full_file\n";
          print "sed -i /transitional.dtd/d $full_file\n";

          #print `sed -i /"DOCTYPE html PUBLIC"/d $full_file`;
          #print `sed -i /transitional.dtd/d $full_file`;

          $counter++;

        } else {

          print "$counter of $counter_all\t$file\n";

        }

        close IN;

      }

      $counter_all++;

    }
  }
}

print "Summary: $counter of $counter_all files changed.\n";

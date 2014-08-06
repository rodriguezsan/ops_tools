#!/usr/bin/perl

use Getopt::Std;
use Pod::Usage;

my $derivative_path = "/var2/dlxs/";
my $archive_path = "/var/projects/lso/images/archive";
my $ic_path = "/var/projects/lso/dlxs11a/img";
my $tc_path = "/var/projects/lso/dlxs11a/obj";

my $file_count = 0;
my $filesize_count = 0;

my $config = "/home/redmonp/scripts/dlinv/dlinv.conf";
my %collid_list = undef;
my $file_out = "dlinv.txt.out";
my $data_out = undef;

# begin main routine

open (FILE, "<$config") || die "Couldn't open config file $config: $!";

open (OUT, ">$file_out") || die "Couldn't open config file $config: $!";

while (<FILE>) {
  chomp;
  my ($key,$val) = split(/\t/);
  $collid_list{$key} = $val;
}

foreach my $collid (sort (keys(%collid_list))) {

  if ($collid ne "") {
    my $collname = $collid_list{$collid};

    $collid =~ m/^(\w)(\w)(\w)/;
    my $c = $1;
    my $d = $2;
    my $e = $3;

    $data_out .= "$collid\n  $collname\n";
    print "Processing $collid\n  $collname\n";
 
    &runInv ("$archive_path/$collid", "Archive"); #archive data
    &runInv ("$ic_path/$c/$collid/jp2", "Jp2"); #image class jp2
    &runInv ("$ic_path/$c/$collid/sid", "Sid"); #image class sid
    &runInv ("$tc_path/$c/$d/$e", "Text"); #text class data
    &runInv ("$ic_path/$c/$collid/jpg", "Jpg"); #image class jpg 

  } 
  print "\n";
  $data_out .= "\n";
}

$filesize_count = $filesize_count/1024/1024;
$data_out .= "Summary:\n\tTotal File Count = $file_count\n\tTotal Disk Usage= $filesize_count GB\n";

print OUT $data_out;

closedir FILE;
closedir OUT;

# begin subroutines

sub runInv {
  my ($path, $type) = @_;
  if (-d "$path") { #text class data
    $data_out .= "  $type\n";
    $data_out .= "    Files: ".&getFileCount ($path);
    $data_out .= "    Size: ".&getFileSize ($path);
  } else {
    $data_out .= "  ".&checkDir ($path);
  }
}

sub getFileCount {
  my ($path) = @_;
  my $out = `ls -1R $path | wc -l`;
  $file_count = $file_count + $out;
  return $out;
}

sub getFileSize {
  my ($path) = @_;
  my $out = `du -s $path | awk '{print \$1}'`;
  $filesize_count = $filesize_count + $out;
  return $out;
}

sub checkDir {
  my ($path) = @_;
  my $out = undef;
  if (-d "$path") {
    $out = "$path exists\n";
  } else {
    $out = "$path does not exist\n";
  }
  return $out;
}

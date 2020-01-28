#!/usr/bin/perl 

# i want a program to find files constantly like gnu find to keep the directory in memory
# ionice -c 3 ./all_find.pl
# echo 100 > /proc/sys/vm/vfs_cache_pressure
#use strict;
use v5.10;
use File::Find;
use Getopt::Long;

my $chunk= 3900; # read about 3900 files at a time before the period 
my $count=0;   # just count until reaches chunk 
my $sleeptime =5;

GetOptions ( 'h', \$help, 'help', \$help, 'c=i', \$chunk, 'q', \$quiet ) or exit;
\helptext() if $help;
my @fdirs = @ARGV;  # don't put this above GetOptions

if (0 == scalar @fdirs) {
	print "-------> please specify a directory to keep in cache.\n\n" ;helptext3();
	helptext() ;
}

unless ($quiet) { 
	foreach  (@fdirs) { 
		if (!-d ) { say  "not a directory error $_ "; exit 1;} # must exist
	}
	helptext3(); 
	say "walking ", scalar (@fdirs), " directories.";
}

# user configurable.  everything is the list of dirs, then the pause time, then the chunk size
sub helptext { 
print <<HR
Usage:  all_find.pl [OPTION] directory [additional dir] .. 

This program slowly walks each directory tree, to keep the VFS tree in the page cache
this means that other programs will find the directory tree has been cached by Linux
it's not foolproof, but just runs slowly until you stop it.

 -q, 	suppress startup message
 -c, 	set count of files to scan before going to sleep for 5s 
		defaults to $chunk scans

HR
; helptext2(); 
}

sub helptext2 { 
say  scalar ((split/\//, $0)[-1]) . " isn't great on CPU usage, but it's very good on memory, tends to use";
say "about 7MB. It should use  a few minutes of CPU per week.";
say "GNU find uses about 1s of CPU per 500,000 files, since I measured.";
say "This program won't save your cache from being stomped on by rsync.";
say "it will keep the tree cached in memory under light pressure though.";
say "installing the nocache utility might help with the rsync problem though.";
say "samba dir trees aren't kept in the linux cache.  NFS dir trees are, though.";

sub helptext3 { 
say "this does not cache files, it ensures that the directories that contain file inodes are kept in cache.";
}
exit;
}

sub echostart { 
say 'starting normal';
}


sub wanted {  # uh actually get's called for each damn thing
	#say $_;
	if ($count > $chunk) { 
		$count=0;
		sleep $sleeptime;  # pause everything for x seconds. 
	}
	$count++; 
}


while (true) {
	foreach (@fdirs) {  # loop through each directory in turn 
		sleep $sleeptime; # extra delay when switching directories
		find ( \&wanted,$_);
	}
}
	



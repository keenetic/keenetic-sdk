#!/usr/bin/env perl
#
# Copyright (C) 2021 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

use strict;
use Getopt::Long qw(:config no_auto_abbrev no_ignore_case);

my $basedir = '';
my $kernel = '';
my $verbose = 0;

GetOptions(
	"basedir|b=s"       => \$basedir,
	"kernel|k=s"        => \$kernel
);

my $usage = <<TXT;
Usage: $0 -b <basedir> -k <version>

Arguments:
   -h --help          : Show this help screen
   -b --basedir       : Modules base directory
   -k --kernel        : Kernel version

Examples:
   $0 -b build_dir/target-mipsel-linux-uclibc_uClibc/root-mt7628 -k 4.9-ndm-4
   
TXT

if (!($basedir && $kernel)) {
	printf $usage;
	exit 0;
}

my $modulesdir = $basedir . '/lib/modules/' . $kernel;
if (!-d $modulesdir) {
	warn "The directory '$modulesdir' doesn't exist\n";
	exit 1;
}

if (system("/sbin/depmod -b $basedir $kernel")) {
	warn "depmod failed with exit code $?\n";
	exit 1;
}

my $dep_mod = "$modulesdir/modules.dep";
open FILE, "<$dep_mod" or do {
	warn "Can't open '$dep_mod': $!\n";
	exit 1;
};

my $count = 0;
my @modules;
my @resolved;
while (my $line = <FILE>) {
	if ($line =~ /^(.*?).ko:[ ]?(.*?)$/){
		if (!$2) {
			printf "Adding \"$1\" to resolved\n" if $verbose;
			push(@resolved, $1);
		} else {
			my $module = {};

			$module->{name} = $1;
			$module->{deps} = [ split / /, $2 ];
			@modules[$count] = $module;

			$count++;
		}
	}
}

close FILE;

while ($count) {
	printf "Count = $count\n" if $verbose;

	for (my $i = 0; $i < $count; $i++) {
		my $ready = 0;

		foreach my $dep (@{$modules[$i]->{deps}}) {
			$dep =~ s/.ko//;
			printf "greping $dep in " . join(" ", @resolved) . "\n" if $verbose;

			if (grep(/$dep/, @resolved)) {
				printf "Resolved $dep from $modules[$i]->{name}\n" if $verbose;
				$ready = 1;
			} else {
				printf "UNResolved \"$dep\" from $modules[$i]->{name}\n" if $verbose;
				$ready = 0;
			}

			last if $ready == 0;
		}

		if ($ready) {
			printf "Adding resolved $modules[$i]->{name}, count = $count\n" if $verbose;

			push(@resolved, $modules[$i]->{name});
			splice @modules, $i, 1;

			$count--;
			$i--;
		}
	}
}

print join(' ', @resolved);
print "\n";

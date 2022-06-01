#!/usr/bin/env perl

use strict;

my $incdir=$ARGV[0];

while (<STDIN>) {
	if (/^\s*!!! include\s+(\S+)/)
	{
		open F, "$incdir/$1" or
			die "Cannot include $incdir/$1";

		while (<F>)
		{
			print;
		}
	} else {
		print;
	}
}


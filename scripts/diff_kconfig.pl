#!/usr/bin/env perl
use warnings;
use strict;

my %config;
my $PREFIX = "CONFIG_";

sub set_config($$$$) {
	my $config = shift;
	my $arg = shift;
	my $idx = shift;
	my $newval = shift;

# 	if (!defined($config->{$idx}->{$arg}) or
# 	    $config->{$idx}->{$arg} eq '#undef' or $newval eq 'y') {
		$config->{$idx}->{$arg} = $newval;
# 	}
}

sub load_config($$) {
	my $file = shift;
	my $arg = shift;

	open FILE, "$file" or die "can't open file";
	while (<FILE>) {
		chomp;
		/^$PREFIX(.+?)=(.+)/ and do {
			set_config(\%config, $arg, $1, $2);
			next;
		};
		/^# $PREFIX(.+?) is not set/ and do {
			set_config(\%config, $arg, $1, "#undef");
			next;
		};
		/^#/ and next;
		/^(.+)$/ and warn "WARNING: can't parse line: $1\n";
	}
	close(FILE);
}

sub dump_diff() {
  foreach my $line (sort {$a cmp $b} keys %config) {
#     if ((%config->{$line}->{1} ne %config->{$line}->{2}) and ()) {
    if (defined(%config->{$line}->{1}) and 
	defined(%config->{$line}->{2}) and
	(%config->{$line}->{1} ne %config->{$line}->{2})) {
      printf ("%-40s = %-11s\t%-11s\n",$line,%config->{$line}->{1},%config->{$line}->{2});
    }
  }
}

my $cfg1 = shift;
my $cfg2 = shift;

load_config($cfg1,1);
load_config($cfg2,2);

# foreach my $line (keys %config) {
#   if (defined(%config->{$line}->{1}) and !defined(%config->{$line}->{2})) {
#     %config->{$line}->{2} = "Not found!";
#   }
#   elsif (!defined(%config->{$line}->{1}) and defined(%config->{$line}->{2})) {
#     %config->{$line}->{1} = "Not found!";
#   }
# }
dump_diff();
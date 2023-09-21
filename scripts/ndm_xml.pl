#!/usr/bin/env perl
#
# Copyright (C) 2021 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

use strict;
use XML::LibXML;

my $xml = "$ENV{'TOPDIR'}/package/private/ndm/files-ndm/etc/components.xml";

splice @ARGV, 0, 5;

my %components;
for (split(' ', shift @ARGV)) {
	$components{$_} = 1;
}

my $dom = XML::LibXML->load_xml(location => $xml, no_blanks => 1);

foreach my $node ($dom->findnodes('/components/component/name')) {
	my $n = $node->to_literal();

	next if $components{$n};

	my $c = $node->parentNode;
	$c->parentNode->removeChild($c);
}

print $dom->toString(1);

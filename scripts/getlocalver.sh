#!/usr/bin/env sh
#
# Copyright (C) 2021 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

beginswith() {
	case $2 in
		"$1"*)
			true;;
		*)
			false;;
	esac
}

try() {
	local count
	local current_branch
	local last_tag

	current_branch=$(git rev-parse --abbrev-ref HEAD)
	beginswith NDMS- "$current_branch" || return 1

	last_tag=$(git describe --abbrev=0)
	[ -z "$last_tag" ] && return 1

	count=$(git rev-list --count $current_branch ^$last_tag)
	[ -z "$count" ] && return 1

	VER=$current_branch-$count
	return 0
}

try || VER="none"
echo "$VER"

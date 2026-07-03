#!/usr/bin/env bash
#
# Copyright (C) 2021 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

# $1 - bin
# $2 - regex
bin_regex_exists () {
	strings "$1" | grep -Eq "$2"
}

if [ $# -ne 2 ]; then
	echo "Usage: $0 <bin> <header.h>"
	exit 0
fi

readonly GFH_HDR="4d4d4d01"
readonly ATF_HDR="88168858"
readonly FIP_HDR="010064aa"

bin_path=$1
head_path=$2

bin_name=$(basename $bin_path)
bin_dir=$(dirname $bin_path)
bin_type=$(echo $bin_name | cut -d '.' -f 1 | tr a-z A-Z)

check_boot_version() {
	local bootloader_regex='^BootLoader v\..+ \[.+\] \(.+\), \(c\)' # actual
	local boot_ver

	if bin_regex_exists "$bin_name" "$bootloader_regex"; then
		boot_ver=$(strings "$bin_name" | grep -E "$bootloader_regex" | cut -d ' ' -f 3)
	else
		echo "Error: unknown bootloader."
		return 1
	fi

	if [ -z "$boot_ver" ]; then
		echo "Error: can't detect bootloader version."
		return 1
	fi

	echo -e "Bootloader version is \"$boot_ver\"."
	return 0
}

cd "$bin_dir"

signature=$(xxd -ps -l4 $bin_name)

case $bin_type in
	PRELOADER)
		if [ $signature != $GFH_HDR ]; then
			echo "Error: BL2 file is wrong, signature 0x$GFH_HDR is not found"
			exit 1
		fi
	;;
	ATF)
		if [ $signature != $ATF_HDR ]; then
			echo "Error: ATF file is wrong, signature 0x$ATF_HDR is not found"
			exit 1
		fi
	;;
	BOOT)
		if [ $signature != $FIP_HDR ]; then
			if ! check_boot_version; then
				exit 1
			fi
		else
			echo -e "Detected FIP image."
		fi
	;;
	*)
		echo "Error: unknown type of binary file"
		exit 1
	;;
esac

echo "#ifndef NDM_"$bin_type"_HEADER" > "$head_path"
echo "#define NDM_"$bin_type"_HEADER" >> "$head_path"
echo >> "$head_path"

xxd -i "${bin_name}" >> "$head_path"

echo >> "$head_path"
echo "#endif" >> "$head_path"

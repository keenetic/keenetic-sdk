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
	strings "$1" | egrep -q "$2"
}

if [ $# -ne 2 ]; then
	echo "Usage: $0 <bin> <header.h>"
	exit 0
fi

readonly ATF_SIGNATURE="88168858"

bin_path=$1
head_path=$2

bin_name=$(basename $bin_path)
bin_dir=$(dirname $bin_path)
bin_type=$(echo $bin_name | cut -d '.' -f 1 | tr a-z A-Z)

cd "$bin_dir"

case $bin_type in
	PRELOADER)
	;;
	ATF)
		signature=$(xxd -ps -l4 $bin_name)
		if [ $signature != $ATF_SIGNATURE ]; then
			echo "Error: ATF file is damaged, signature is not found"
			exit 1
		fi
	;;
	BOOT)
		bootloader_regex='^BootLoader v\..+ \[.+\] \(.+\), \(c\)' # actual

		if bin_regex_exists "$bin_name" "$bootloader_regex"; then
			boot_ver=$(strings "$bin_name" | egrep "$bootloader_regex" | cut -d ' ' -f 3)
		else
			echo "Error: unknown bootloader."
			exit 1
		fi

		if [ -z "$boot_ver" ]; then
			echo "Error: can't detect bootloader version."
			exit 1
		fi

		echo -e "Bootloader version is \"$boot_ver\"."
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

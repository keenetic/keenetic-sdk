#!/usr/bin/env bash
#
# Copyright (C) 2021 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

TLV_BLOCK_SIZE=131072
TLV_FILE=.tlv

message () {
        local yellow='\e[1;33m'
        local reset='\e[0m'

        echo -e "${yellow}$@${reset}"
}

squashfs_offset () {
	echo $(grep --byte-offset --max-count=1 --only-matching \
		--text "hsqs" $1 | cut -d : -f 1)
}

tlv_offset () {
	echo $(grep --byte-offset --max-count=1 --only-matching \
		--text "TLV.NDM" $1 | cut -d : -f 1)
}

tlv_profile () {
	local o=$(grep --byte-offset --max-count=1 --only-matching --binary \
		--text --perl-regexp "\x00\x00\x00\x01\x00\x00\x00" $1 | cut -d : -f 1)
	[ -n "$o" ] && echo $(tail -c +$((o+8+1)) $1 | strings | head -1)
}

tlv_components () {
	local o=$(grep --byte-offset --max-count=1 --only-matching --binary \
		--text --perl-regexp "\x00\x00\x00\x12\x00" $1 | cut -d : -f 1)
	[ -n "$o" ] && echo $(tail -c +$((o+8+1)) $1 | strings | head -1)
}

package_dir () {
	echo $(grep "^$1:" tmp/.packagemakefile | cut -d : -f 2 | sed -e 's|/Makefile$||')
}

usage () {
	echo "Usage: $0 <firmware.bin>"
	echo
	echo "Options:"
	echo -e "\t-h - display this help and exit"
	echo -e "\t-v - verbose"
	echo
	echo "Example:"
	echo "$0 20201103_1146_Firmware-KN-2310-3.06.A.2.0-1.bin"
}

NDM_FILES_ROOT=package/private/ndm/files-ndm
NCPU=$(grep processor /proc/cpuinfo | wc -l)
UNSQUASHFS=staging_dir/host/bin/unsquashfs4
VERBOSE=

while getopts hv opt; do
	case $opt in
		h)
			usage
			exit 0
			;;
		v)
			VERBOSE="V=s"
			;;
	esac
done

shift $((OPTIND - 1))

if [ $# -ne 1 ]; then
	usage
	exit 0
fi

FIRMWARE=$1

TLV_OFFSET=$(tlv_offset $FIRMWARE)
if [ -z "$TLV_OFFSET" ]; then
	echo "Unable to find TLV table offset."
	exit 1
fi

if ! dd if=$FIRMWARE of=$TLV_FILE bs=1 count=$TLV_BLOCK_SIZE skip=$TLV_OFFSET status=none; then
	echo "Unable to copy TLV table."
	exit 1
fi

PROFILE=$(tlv_profile $TLV_FILE)
if [ -z "$PROFILE" ]; then
	echo "Unable to detect device."
	rm $TLV_FILE
	exit 1
fi

COMPONENTS=$(tlv_components $TLV_FILE)
if [ -z "$COMPONENTS" ]; then
	echo "Unable to detect components."
	rm $TLV_FILE
	exit 1
fi

rm $TLV_FILE

message "[Information]"
echo -e "file:\t\t$FIRMWARE"
echo -e "hardware_id:\t$PROFILE"
echo -e "components:\t$COMPONENTS"
echo

message "[Configuring]"
if ! echo $COMPONENTS | ./configure.sh -pmanual $PROFILE; then
	echo "Unable to configure."
	exit 1
fi

echo

message "[Building host tools]"
if ! make -j$NCPU tools/squashfskit4/install $VERBOSE; then
	echo "Unable to build host tools."
	exit 1
fi

echo

message "[Unpacking root filesystem]"
OFFSET=$(squashfs_offset $FIRMWARE)
if ! $UNSQUASHFS -force -offset $OFFSET -regex $FIRMWARE \
	'^([^d].*$)|(d([^e].*$|$))|(de([^v].*$|$))|(dev.+$)'; then
	echo "Unable to unpack root filesystem."
	exit 1
fi

if ! scripts/metadata.pl package_makefile tmp/.packageinfo > tmp/.packagemakefile; then
	echo "Unable to generate .packagemakefile file."
	exit 1
fi

find squashfs-root -type f -print0 | while IFS= read -r -d '' i; do
	p=$(getfattr $i --match='user.package' --only-values)
	[ -z "$p" ] && continue

	d=$(dirname $i)
	d=${d#squashfs-root}
	n=$(basename $i)
	sd=squashfs-root/$d
	dd=$(package_dir $p)/files-${p#kmod-}/$d

	mkdir --parents $dd
	chmod --reference=$sd $dd
	cp --preserve=mode,xattr $sd/$n $dd/$n
done

rm tmp/.packagemakefile

if [ -d squashfs-root/storage ]; then
	mkdir $NDM_FILES_ROOT/storage
	chmod --reference=squashfs-root/storage $NDM_FILES_ROOT/storage
fi

find squashfs-root -type l ! -path squashfs-root/var -print0 | while IFS= read -r -d '' i; do
	d=$(dirname $i)
	d=${d#squashfs-root}
	n=$(basename $i)
	sd=squashfs-root/$d
	dd=$NDM_FILES_ROOT/$d

	mkdir --parents $dd
	chmod --reference=$sd $dd
	cp --no-dereference $sd/$n $dd/$n
done

rm -rf squashfs-root

echo

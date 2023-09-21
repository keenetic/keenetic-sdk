#!/usr/bin/env bash
#
# Copyright (C) 2021 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

PRESET=
PRESETS_CFG=package/private/ndm/presets.json
REMOVE_MODULES=false

# $1 - config
# $2 - option
kconfig_string_value () {
	echo $(egrep "$2=.*$" $1 | cut -d = -f 2 | tr -d \")
}

# $1 - config
config_boardname_get () {
	kconfig_string_value $cfg CONFIG_TARGET_DESCRIPTION
}

# $1 - config
config_target_get () {
	kconfig_string_value $1 CONFIG_TARGET_BOARD
}

# $1 - config
config_subtarget_get () {
	kconfig_string_value $1 CONFIG_TARGET_ARCH_PACKAGES
}

# $1 - config
config_profile_get () {
	kconfig_string_value $1 CONFIG_TARGET_PROFILE
}

# $1 - config
config_subtarget_dir_get () {
	local profile=$(config_profile_get $1)
	local target=$(config_target_get $1)
	local subtarget=$(config_subtarget_get $1)

	if [ $profile != Default ]; then
		echo "target/linux/$target/$subtarget/$profile"
	else
		echo "target/linux/$target/$subtarget"
	fi
}

# $1 - config
config_components_all_get () {
	echo $(sed -ne 's|^CONFIG_PACKAGE_ndm-mod-\(.*\)=[my]$|\1|p' $1 | sort)
}

# $1 - config
config_components_get () {
	echo $(sed -ne 's|^CONFIG_PACKAGE_ndm-mod-\(.*\)=y$|\1|p' $1 | sort)
}

# $1 - config
# $2 - do backup
BACKUP_SUFFIX="~"
cfg_cleanup() {
	local cfg=$1
	local backup=$2
	local prefix_path=tmp/cleanup_step
	local s

	if [ ! -e $cfg ]; then
		echo "Error: file \"$cfg\" doesn't exist."
		return 1
	fi

	echo "Cleanup..."
	echo

	make $cfg 2>&1 | tee .pipe
	if [ ${PIPESTATUS[0]} -ne 0 ]; then
		rm .pipe
		return 1
	fi

	[ -s .pipe ] && echo
	rm .pipe

	egrep -v '^CONFIG_PACKAGE_' -v $cfg > ${prefix_path}_1
	egrep '^CONFIG_PACKAGE_ndm-mod-' $cfg > ${prefix_path}_2

	scripts/kconfig.pl '+' ${prefix_path}_1 ${prefix_path}_2 > ${prefix_path}_3
	scripts/config/conf --defconfig=${prefix_path}_3 -w ${prefix_path}_4 Config.in >/dev/null

	s=
	$backup && s=--backup=simple
	SIMPLE_BACKUP_SUFFIX=$BACKUP_SUFFIX \
		cp $s ${prefix_path}_4 $cfg

	rm ${prefix_path}_*

	echo "Done!"

	if $backup; then
		echo
		echo "Backup saved to file \"${cfg}${BACKUP_SUFFIX}\"."
	fi
}

presets_list () {
	if [ -e $PRESETS_CFG ]; then
		t=$(jq -r 'keys | join(" ")' $PRESETS_CFG)
	fi
	echo -e "all manual\n$t"
}

# $1 - config
# $2 - preset
preset_apply () {
	local cfg=$1
	local preset=$2
	local components
	local t

	if [ ! -e $cfg ]; then
		echo "Error: file \"$cfg\" doesn't exist."
		return 1
	fi

	cp $cfg .config_backup
	sed -i 's/^\(CONFIG_PACKAGE_ndm-mod-.*=\)y$/\1m/' $cfg
	rm -f tmp/presets.json

	make $cfg 2>&1 | tee .pipe
	if [ ${PIPESTATUS[0]} -ne 0 ]; then
		rm .pipe
		mv .config_backup $cfg
		return 1
	fi

	[ -s .pipe ] && echo
	rm .pipe

	if [ $preset = "all" ]; then
		t=$(config_components_all_get $cfg | tr ' ' '\n')
	elif [ $preset = "manual" ]; then
		echo "Paste comma-separated list from \"show version\" and press Ctrl+D."
		t=$(cat | tr -d '\n\t ' | tr ',' '\n')
	else
		t=$(jq -r ".$preset[]" tmp/presets.json)
	fi

	t+=$'\ncomponents'	# hidden and always needed
	t+=$'\nndss-override'	# NDMS-893
	components=$(echo "$t" | sort | uniq)

	echo "Preset \"$preset\":"
	for i in $components; do
		t=CONFIG_PACKAGE_ndm-mod-$i

		if ! grep -q "^$t=.*$" $cfg; then
			if [ $preset != "manual" ]; then
				continue
			else
				echo "Error: component \"$i\" doesn't exist."
				mv .config_backup $cfg
				return 1
			fi
		fi

		echo -e "\t$i"
		sed -i "s/^\($t=\)m$/\1y/" $cfg
	done
	echo

	if [ "$REMOVE_MODULES" = true ]; then
		sed -i 's/^\(CONFIG_PACKAGE_ndm-mod-.*\)=m$/# \1 is not set/' $cfg
	fi

	rm .config_backup
	cfg_cleanup $cfg false >/dev/null
}

list_configs () {
	targets=$(find target/linux/ -maxdepth 1 -type d ! -name generic ! -name linux | cut -d / -f 3 | sort)

	for t in $targets; do
		devices=$(find target/linux/$t -maxdepth 1 -type d ! -name image | cut -d / -f 4 | sort)

		echo $t:

		for d in $devices; do
			if [ -f target/linux/$t/$d/ndwrt.config ]; then
				DESCRIPTION=$(grep DESCRIPTION target/linux/$t/$d/target.mk | cut -d = -f 2)

				if [ $d == "generic" ]; then
					printf "\t%-10s\t%-25s\r\n" "${t}" "${DESCRIPTION}"
				else
					printf "\t%-10s\t%-25s\r\n" "${d}" "${DESCRIPTION}"
				fi

				profiles=$(find target/linux/$t/$d \
					-maxdepth 1 -type d \
					! -name profiles \
					! -name 'base-files*' \
					! -name 'ndm-mod-files' | \
					cut -d / -f 5)
				if [ -n "$profiles" ]; then
					for p in $profiles; do
						profile_name=$(grep NAME target/linux/$t/$d/profiles/${p}.mk | cut -d = -f 2)
						printf "\t%-10s\t%-25s\t%s\r\n" "${d}_${p}" "${DESCRIPTION}" "${profile_name}"
					done
				fi
			fi
		done

		echo
	done
}

# $1 - config
cfg_copy () {
	local path=$1
	local NCPU=$(grep processor /proc/cpuinfo | wc -l)

	let NCPU=1+${NCPU}

	echo "Creating configuration file..."
	echo

	cp $path .config

	if [ -n "$PRESET" ]; then
		if ! preset_apply .config $PRESET; then
			rm .config
			return 1
		fi
	fi

	echo "Done!"
	echo
	echo "You can build firmware as \"make -j${NCPU}\" or \"make -j${NCPU} V=s\""
	echo
}


# $1 - config
cfg_info () {
	local cfg=$1
	local first
	local name
	local subtarget
	local target
	local profile
	local path

	if [ ! -e $cfg ]; then
		echo "Error: file \"$cfg\" doesn't exist."
		return 1
	fi

	name=$(config_boardname_get $cfg)
	target=$(config_target_get $cfg)
	subtarget=$(config_subtarget_get $cfg)
	profile=$(config_profile_get $cfg)
	path=$(config_subtarget_dir_get $cfg)

	if [ $target == $subtarget ]; then
		subtarget=generic
		profile=Default
	fi

	echo "=================================================="
	echo -e "Name:\t\t$name"
	echo "=================================================="
	echo -e "Target:\t\t$target"
	echo -e "Subtarget:\t$subtarget"
	[ $profile != Default ] && echo -e "Profile:\t$profile"
	echo "=================================================="
	echo -ne "Components:"
	first=true
	for i in $(config_components_get $cfg); do
		if [ "$first" = true ]; then
			echo -ne "\t$i"
			first=false
		else
			echo -ne ",\n\t\t$i"
		fi
	done
	echo
	echo -e "Path:\t\t$path"
	echo "=================================================="

	return 0
}

# $1 - config
cfg_save () {
	local file
	local cfg=$1

	if [ ! -e $cfg ]; then
		echo "Error: file \"$cfg\" doesn't exist."
		return 1
	fi

	file=$(config_subtarget_dir_get $cfg)/ndwrt.config

	cp $cfg $file
	echo -e "$cfg\t-> $file"

	return 0
}

# $1 - config
cfg_diff () {
	local file
	local cfg=$1

	if [ ! -e $cfg ]; then
		echo "Error: file \"$cfg\" doesn't exist."
		return 1
	fi

	file=$(config_subtarget_dir_get $cfg)/ndwrt.config
	if [ ! -e $file ]; then
		echo "Error: file \"$file\" doesn't exist."
		return 1
	fi

	${DIFF:-diff} -uprN $file $cfg | \
		less --quit-if-one-screen --no-init --RAW-CONTROL-CHARS

	return 0
}

usage () {
	echo "Usage: $0 [OPTION] <device>"
	echo
	echo "Options:"
	echo -e "\t-c - clean current config"
	echo -e "\t-d - display diff between saved and current config"
	echo -e "\t-h - display this help and exit"
	echo -e "\t-i - display information about current config"
	echo -e "\t-l - list all devices"
	echo -e "\t-p <preset>" - apply given preset
	echo -e "\t-r - remove components selected as modules (only with -p)"
	echo -e "\t-s - save current config"
	echo
	echo "Available presets:"
	for i in $(presets_list); do
		echo -e "\t$i"
	done
}

ACTION=
while getopts cdhilp:rs opt; do
	case $opt in
		h)
			usage
			exit 0
			;;
		c)
			ACTION=cleanup
			;;
		d)
			ACTION=diff
			;;
		i)
			ACTION=info
			;;
		l)
			ACTION=list
			;;
		s)
			ACTION=save
			;;
		p)
			PRESET=$OPTARG
			;;
		r)
			REMOVE_MODULES=true
			;;

	esac
done

case $ACTION in
	cleanup)
		cfg_cleanup .config true
		exit $?
		;;
	diff)
		cfg_diff .config
		exit $?
		;;
	info)
		cfg_info .config
		exit $?
		;;
	save)
		cfg_save .config
		exit $?
		;;
	list)
		list_configs
		exit 0
		;;
esac

shift $((OPTIND - 1))

if [ $# -ne 1 ]; then
	usage
	exit 0
fi

if [ -n "$PRESET" ]; then
	echo $(presets_list) | grep -qw $PRESET
	if [ $? -ne 0 ]; then
		echo "Error: bad preset. See help."
		exit 1
	fi
fi

rm -f .config

board_path=$(find target/linux -name $1)
if [ -f ${board_path}/ndwrt.config ]; then
	cfg_copy "${board_path}/ndwrt.config"
	exit $?
fi

targets=$(find target/linux/ -maxdepth 1 -type d ! -name generic ! -name linux | cut -d / -f 3)
for t in $targets; do
	devices=$(find target/linux/$t -maxdepth 1 -type d ! -name image | cut -d / -f 4)

	for d in $devices; do
		if [ "${t}" == "$1" ]; then
			cfg_copy target/linux/$t/generic/ndwrt.config
			exit $?
		fi

		profiles=$(find target/linux/$t/$d -maxdepth 1 -type d ! -name profiles ! -name base-files | cut -d / -f 5)
		if [ -n "$profiles" ]; then
			for p in $profiles; do
				if [ "${d}_${p}" == "$1" -a -f target/linux/$t/$d/$p/ndwrt.config ]; then
					cfg_copy target/linux/$t/$d/$p/ndwrt.config
					exit $?
				fi
			done
		fi
	done
done

echo "Error: device \"$1\" doesn't exist."
exit 1

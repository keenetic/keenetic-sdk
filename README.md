# Keenetic SDK

This is the build system for the KeeneticOS.

Keenetic SDK is based on the OpenWrt Buildroot (https://openwrt.org/). We recommend to read the
OpenWrt build system manual (https://openwrt.org/docs/guide-developer/build-system/use-buildsystem)
before following the next steps.

## Important notice

This source code includes software distributed under the GNU General Public License (GPL) and other
applicable open source licenses. Nothing in this notice modifies, limits, or overrides any rights
granted under those licenses.

Keenetic does not endorse or support the use of this software for unlawful, malicious, or otherwise
harmful activities, including unauthorized access to computer systems, interference with networks or
services, or any activity that infringes the rights of others or violates applicable laws.

This software is provided "as is", without warranties of any kind, to the extent permitted by the
applicable licenses and law. Users are solely responsible for ensuring that their use of the
software complies with all applicable laws and regulations.

## Step 1. Save the current version of KeeneticOS

Connect to the Keenetic web interface and go to the 'System settings' page.
In the 'System files' section, select the firmware file and click the 'Save to computer' button to
download the copy of this file.

Write down the version of KeeneticOS (e.g. `5.01.C.6.0-1`).

## Step 2. Set up your environment

You need the 64-bit Debian-based Linux distribution.
We recommend to use the latest long-term support (LTS) version of Ubuntu (https://ubuntu.com/download).

	# apt install attr bc bsdmainutils build-essential curl file gawk git gperf jq libhtml-parser-perl libjson-perl libncurses-dev libssl-dev libxml-libxml-perl lzip protobuf-c-compiler python3 subversion unzip zlib1g-dev

## Step 3. Prepare source

	$ # replace '<version>' below with yours from Step 1
	$ git clone --depth 1 --branch <version> https://github.com/keenetic/keenetic-sdk.git
	$ cd keenetic-sdk

## Step 4. Unpack firmware

	$ # replace '<firmware.bin>' below with the path to your firmware from Step 1
	$ ./unpack.sh <firmware.bin>

## Step 5. Build firmware

	$ make -j$(grep processor /proc/cpuinfo | wc -l)

You can find the firmware file in the 'bin' directory (e.g. `bin/mt7621/20260916_2212_KN-1010-5.01.C.6.0-1.bin`)

## Step 6. Customization

You can put your files in the 'files' directory.
You can also put packages for building your software in the 'package' directory

See:
https://openwrt.org/docs/guide-developer/packages

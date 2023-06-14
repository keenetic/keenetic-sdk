# Keenetic SDK

This is the build system for the KeeneticOS.

Keenetic SDK is based on the OpenWrt project (https://openwrt.org/).
We recommend to read the OpenWrt build system manual (https://openwrt.org/docs/guide-developer/build-system/use-buildsystem) before following the next steps.

## Step 1. Save the current version of KeeneticOS

Connect to the Keenetic web interface and go to the 'System settings' page.
In the 'System files' section, select the firmware file and click the 'Save to computer' button to download the copy of this file.

Write down the version of KeeneticOS (e.g. `3.08.C.8.0-0`).

## Step 2. Set up your environment

You need the 64-bit Debian-based Linux distribution.
We recommend to use the latest long-term support (LTS) version of Ubuntu (https://ubuntu.com/download).

	# apt install attr bc build-essential curl gawk git libhtml-parser-perl libjson-perl libncurses-dev libssl-dev libxml-libxml-perl python python3 subversion unzip zlib1g-dev

## Step 3. Prepare source

	$ # replace '<version>' below with yours from Step 1
	$ git clone --depth 1 --branch <version> https://github.com/keenetic/keenetic-sdk.git
	$ cd keenetic-sdk

## Step 4. Unpack firmware

	$ # replace '<firmware.bin>' below with the path to your firmware from Step 1
	$ ./unpack.sh <firmware.bin>

## Step 5. Build firmware

	$ make

You can find the firmware file in the 'bin' directory (e.g. `bin/mt7621/20230614_1847_KN-1010-3.08.C.8.0-0.bin`)

## Step 6. Customization

You can put your files in the 'files' directory.
You can also put packages for building your software in the 'package' directory

See:
https://openwrt.org/docs/guide-developer/packages

# Keenetic SDK

This is the buildsystem for the KeeneticOS.

Keenetic SDK is based on the OpenWrt project (https://openwrt.org/).
We recommend to read OpenWrt build system manual (https://openwrt.org/docs/guide-developer/build-system/use-buildsystem) before following the next steps.

## Step 1. Save the current version of KeeneticOS

Connect to the Keenetic web interface and go to the 'System settings' page.
In the 'System files' section, select the firmware file and click the 'Save to computer' button to download the copy of this file.

Write down the version of KeeneticOS (e.g. '3.07.A.1.0-1').

## Step 2. Set up environment

You need 64-bit Debian-based Linux distribution.
We recommend to use lastest long-term support (LTS) version of Ubuntu (https://ubuntu.com/download).

	# apt install bc build-essential curl file git libjson-perl libhtml-parser-perl

## Step 3. Prepare source

	$ # replace '<version>' below with yours from Step 1
	$ git clone --depth 1 --branch <version> https://github.com/keenetic/keenetic-sdk.git 
	$ cd keenetic-sdk

## Step 4. Unpack firmware

	$ # replace '<firmware.bin>' below with the path to your firmware from Step 1 
	$ ./unpack.sh <firmware.bin>

## Step 5. Build firmware
	
	$ make

You can find the firmware file in the 'bin' directory (e.g. `bin/mt7628/20210320_1100_Firmware-Keenetic_Air-3.07.A.1.0-0.bin`)

## Step 6. Customization

You can put your files in the 'files' directory.
You can also put packages for building your software in the 'package' directory

See:
https://openwrt.org/docs/guide-developer/packages

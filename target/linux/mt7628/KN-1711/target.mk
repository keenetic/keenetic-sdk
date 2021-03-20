#
# Copyright (C) 2021 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

SUBTARGET:=KN-1711
DESCRIPTION:=Extra / Carrier
BOARD_CPPFLAGS += -D__KN_1711__
DEFAULT_PACKAGES += ndm-mod-interface-extras
FEATURES += usb usbstorage
CFLAGS:=-Os -pipe -mips32r2 -mtune=mips32r2

define Target/Description
	Build firmware images for KN-1711
endef


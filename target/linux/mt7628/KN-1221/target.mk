#
# Copyright (C) 2024 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

SUBTARGET:=KN-1221
DESCRIPTION:=Launcher
BOARD_CPPFLAGS += -D__KN_1221__
DEFAULT_PACKAGES += ndm-mod-interface-extras
FEATURES += usb
CFLAGS:=-Os -pipe -mips32r2 -mtune=mips32r2

define Target/Description
	Build firmware images for KN-1221
endef


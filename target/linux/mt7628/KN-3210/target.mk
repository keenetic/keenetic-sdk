#
# Copyright (C) 2021 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

SUBTARGET:=KN-3210
DESCRIPTION:=Buddy 4
BOARD_CPPFLAGS += -D__KN_3210__
DEFAULT_PACKAGES += ndm-mod-interface-extras
CFLAGS:=-Os -pipe -mips32r2 -mtune=mips32r2
DEVICE_TYPE:=extender

define Target/Description
	Build firmware images for KN-3210
endef


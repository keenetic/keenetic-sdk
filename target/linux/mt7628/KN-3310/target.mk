#
# Copyright (C) 2021 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

SUBTARGET:=KN-3310
DESCRIPTION:=Buddy 5
BOARD_CPPFLAGS += -D__KN_3310__
DEFAULT_PACKAGES += ndm-mod-interface-extras
CFLAGS:=-Os -pipe -mips32r2 -mtune=mips32r2
DEVICE_TYPE:=extender

define Target/Description
	Build firmware images for KN-3310
endef


#
# Copyright (C) 2023 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

SUBTARGET:=KN-3311
DESCRIPTION:=Buddy 5
BOARD_CPPFLAGS += -D__KN_3311__
DEFAULT_PACKAGES += ndm-mod-interface-extras
CFLAGS:=-Os -pipe -mips32r2 -mtune=mips32r2
DEVICE_TYPE:=extender

define Target/Description
	Build firmware images for KN-3311
endef


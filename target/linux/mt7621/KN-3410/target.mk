#
# Copyright (C) 2021 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

SUBTARGET:=KN-3410
DESCRIPTION:=Buddy 5S
BOARD_CPPFLAGS += -D__KN_3410__
DEFAULT_PACKAGES += ndm-mod-interface-extras
DEVICE_TYPE:=extender

define Target/Description
	Build firmware images for KN-3410
endef


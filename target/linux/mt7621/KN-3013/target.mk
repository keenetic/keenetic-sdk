#
# Copyright (C) 2024 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

SUBTARGET:=KN-3013
DESCRIPTION:=Speedster
BOARD_CPPFLAGS += -D__KN_3013__
DEFAULT_PACKAGES += ndm-mod-interface-extras

define Target/Description
	Build firmware images for KN-3013
endef


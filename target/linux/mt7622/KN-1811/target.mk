#
# Copyright (C) 2021 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

SUBTARGET:=KN-1811
DESCRIPTION:=Ultra / Titan
BOARD_CPPFLAGS += -D__KN_1811__
DEFAULT_PACKAGES += ndm-mod-interface-extras
FEATURES += btmtk

define Target/Description
	Build firmware images for KN-1811
endef


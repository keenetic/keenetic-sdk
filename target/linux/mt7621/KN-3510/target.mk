#
# Copyright (C) 2021 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

SUBTARGET:=KN-3510
DESCRIPTION:=Voyager Pro
BOARD_CPPFLAGS += -D__KN_3510__
DEFAULT_PACKAGES += ndm-mod-interface-extras
FEATURES += btmtk

define Target/Description
	Build firmware images for KN-3510
endef


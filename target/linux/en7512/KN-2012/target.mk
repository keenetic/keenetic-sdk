#
# Copyright (C) 2021 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

SUBTARGET:=KN-2012
DESCRIPTION:=DSL / Launcher DSL
BOARD_CPPFLAGS += -D__KN_2012__
DEFAULT_PACKAGES += ndm-mod-interface-extras
FEATURES += extended_storage

define Target/Description
	Build firmware images for KN-2012
endef

#
# Copyright (C) 2021 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

SUBTARGET:=KN-2111
DESCRIPTION:=Extra DSL / Carrier DSL
BOARD_CPPFLAGS += -D__KN_2111__
DEFAULT_PACKAGES += ndm-mod-interface-extras kmod-ensoc_dsl
FEATURES += old_modes

define Target/Description
	Build firmware images for KN-2111
endef

#
# Copyright (C) 2021 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

SUBTARGET:=KN-2011
DESCRIPTION:=Omni DSL / Hopper DSL
BOARD_CPPFLAGS += -D__KN_2011__
DEFAULT_PACKAGES += ndm-mod-interface-extras kmod-ensoc_dsl
FEATURES += old_modes extended_storage

define Target/Description
	Build firmware images for KN-2011
endef

#
# Copyright (C) 2024 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

SUBTARGET:=KN-2013
DESCRIPTION:=Explorer DSL
BOARD_CPPFLAGS += -D__KN_2013__
DEFAULT_PACKAGES += ndm-mod-interface-extras
FEATURES += dsl_en751x

define Target/Description
	Build firmware images for KN-2013
endef

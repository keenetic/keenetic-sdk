#
# Copyright (C) 2021 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

SUBTARGET:=KN-2510
DESCRIPTION:=Ultra SE / Peak DSL
BOARD_CPPFLAGS += -D__KN_2510__
DEFAULT_PACKAGES += ndm-mod-interface-extras

define Target/Description
	Build firmware images for KN-2510
endef

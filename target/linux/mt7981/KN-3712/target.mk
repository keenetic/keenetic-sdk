#
# Copyright (C) 2023 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

SUBTARGET:=KN-3712
DESCRIPTION:=Sprinter SE
BOARD_CPPFLAGS += -D__KN_3712__
DEFAULT_PACKAGES += ndm-mod-interface-extras
FEATURES += conninfra warp

define Target/Description
	Build firmware images for KN-3712
endef

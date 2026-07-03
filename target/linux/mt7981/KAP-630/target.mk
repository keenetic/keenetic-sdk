#
# Copyright (C) 2024 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

SUBTARGET:=KAP-630
DESCRIPTION:=Orbiter 6
BOARD_CPPFLAGS += -D__KAP_630__
DEFAULT_PACKAGES += ndm-mod-interface-extras
FEATURES += conninfra warp

define Target/Description
	Build firmware images for KAP-630
endef

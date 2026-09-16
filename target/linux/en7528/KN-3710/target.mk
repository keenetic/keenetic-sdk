#
# Copyright (C) 2021 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

SUBTARGET:=KN-3710
DESCRIPTION:=Sprinter
BOARD_CPPFLAGS += -D__KN_3710__
DEFAULT_PACKAGES += ndm-mod-interface-extras

define Target/Description
	Build firmware images for KN-3710
endef

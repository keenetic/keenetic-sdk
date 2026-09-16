#
# Copyright (C) 2024 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

SUBTARGET:=KN-2911
DESCRIPTION:=Speedster 4G+
BOARD_CPPFLAGS += -D__KN_2911__
DEFAULT_PACKAGES += ndm-mod-interface-extras
FEATURES += usb emb_modem

define Target/Description
	Build firmware images for KN-2911
endef


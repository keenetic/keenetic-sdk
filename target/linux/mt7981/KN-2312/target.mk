#
# Copyright (C) 2024 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

SUBTARGET:=KN-2312
DESCRIPTION:=Hopper 4G+
BOARD_CPPFLAGS += -D__KN_2312__
DEFAULT_PACKAGES += ndm-mod-interface-extras
FEATURES += conninfra warp usb emb_modem usbstorage extended_storage

define Target/Description
	Build firmware images for KN-2312
endef

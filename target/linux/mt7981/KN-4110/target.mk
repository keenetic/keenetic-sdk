#
# Copyright (C) 2025 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

SUBTARGET:=KN-4110
DESCRIPTION:=Hero 5G
BOARD_CPPFLAGS += -D__KN_4110__
DEFAULT_PACKAGES += ndm-mod-interface-extras
FEATURES += conninfra warp usb emb_modem usbstorage extended_storage

define Target/Description
	Build firmware images for KN-4110
endef

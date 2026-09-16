#
# Copyright (C) 2024 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

SUBTARGET:=KN-1812
DESCRIPTION:=Ultra / Titan
BOARD_CPPFLAGS += -D__MT7988D__ -D__KN_1812__
DEFAULT_PACKAGES += ndm-mod-interface-extras
FEATURES += warp usb usbstorage extended_storage

define Target/Description
	Build firmware images for KN-1812
endef

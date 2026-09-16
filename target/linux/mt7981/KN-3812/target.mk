#
# Copyright (C) 2023 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

SUBTARGET:=KN-3812
DESCRIPTION:=Hopper SE
BOARD_CPPFLAGS += -D__KN_3812__
DEFAULT_PACKAGES += ndm-mod-interface-extras
FEATURES += conninfra warp usb usbstorage extended_storage

define Target/Description
	Build firmware images for KN-3812
endef

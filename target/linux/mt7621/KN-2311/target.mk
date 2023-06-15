#
# Copyright (C) 2021 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

SUBTARGET:=KN-2311
DESCRIPTION:=Hero 4G+
BOARD_CPPFLAGS += -D__KN_2311__
DEFAULT_PACKAGES += ndm-mod-interface-extras
FEATURES += usb usbstorage extended_storage

define Target/Description
	Build firmware images for KN-2311
endef


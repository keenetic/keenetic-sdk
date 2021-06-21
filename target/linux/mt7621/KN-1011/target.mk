#
# Copyright (C) 2021 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

SUBTARGET:=KN-1011
DESCRIPTION:=Giga6 / Hero6
BOARD_CPPFLAGS += -D__KN_1011__
DEFAULT_PACKAGES += ndm-mod-interface-extras
FEATURES += btmtk usb usbstorage extended_storage

define Target/Description
	Build firmware images for KN-1011
endef


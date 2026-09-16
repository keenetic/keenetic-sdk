#
# Copyright (C) 2021 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

SUBTARGET:=KN-1910
DESCRIPTION:=Viva / Skipper
BOARD_CPPFLAGS += -D__KN_1910__
DEFAULT_PACKAGES += ndm-mod-interface-extras
FEATURES += old_modes usb usbstorage extended_storage

define Target/Description
	Build firmware images for KN-1910
endef


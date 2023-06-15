#
# Copyright (C) 2021 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

SUBTARGET:=KN-1912
DESCRIPTION:=Viva / Skipper
BOARD_CPPFLAGS += -D__KN_1912__
DEFAULT_PACKAGES += ndm-mod-interface-extras
FEATURES += usb usbstorage extended_storage

define Target/Description
	Build firmware images for KN-1912
endef

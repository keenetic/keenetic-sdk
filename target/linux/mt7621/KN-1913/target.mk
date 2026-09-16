#
# Copyright (C) 2024 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

SUBTARGET:=KN-1913
DESCRIPTION:=Viva / Skipper
BOARD_CPPFLAGS += -D__KN_1913__
DEFAULT_PACKAGES += ndm-mod-interface-extras
FEATURES += usb usbstorage extended_storage

define Target/Description
	Build firmware images for KN-1913
endef


#
# Copyright (C) 2023 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

SUBTARGET:=KN-3811
DESCRIPTION:=Hopper
BOARD_CPPFLAGS += -D__KN_3811__
DEFAULT_PACKAGES += ndm-mod-interface-extras
FEATURES += conninfra warp usb usbstorage extended_storage

define Target/Description
	Build firmware images for KN-3811
endef

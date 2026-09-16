#
# Copyright (C) 2024 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

SUBTARGET:=KN-4210
DESCRIPTION:=Titan SE
BOARD_CPPFLAGS += -D__MT7988D__ -D__KN_4210__
DEFAULT_PACKAGES += ndm-mod-interface-extras
FEATURES += warp usb usbstorage extended_storage nvme dsl_en7517

define Target/Description
	Build firmware images for KN-4210
endef

#
# Copyright (C) 2021 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

SUBTARGET:=KN-2410
DESCRIPTION:=Giga SE / Hero DSL
BOARD_CPPFLAGS += -D__KN_2410__
DEFAULT_PACKAGES += ndm-mod-interface-extras
FEATURES += usbstorage extended_storage dsl_en751x

define Target/Description
	Build firmware images for KN-2410
endef

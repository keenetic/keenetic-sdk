#
# Copyright (C) 2023 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

SUBTARGET:=KN-3411
DESCRIPTION:=Buddy 6
BOARD_CPPFLAGS += -D__KN_3411__
DEFAULT_PACKAGES += ndm-mod-interface-extras
DEVICE_TYPE:=extender
FEATURES += conninfra warp

define Target/Description
	Build firmware images for KN-3411
endef

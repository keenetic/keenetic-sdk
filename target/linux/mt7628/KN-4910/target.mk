#
# Copyright (C) 2023 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

SUBTARGET:=KN-4910
DESCRIPTION:=Explorer 4G
BOARD_CPPFLAGS += -D__KN_4910__
DEFAULT_PACKAGES += ndm-mod-interface-extras
FEATURES += usb emb_modem
CFLAGS:=-Os -pipe -mips32r2 -mtune=mips32r2

define Target/Description
	Build firmware images for KN-4910
endef


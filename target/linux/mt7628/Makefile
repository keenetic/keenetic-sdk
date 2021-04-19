#
# Copyright (C) 2021 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

ARCH:=mipsel
BOARD:=mt7628
DESCRIPTION:=MediaTek MT7628
FEATURES:=squashfs
CFLAGS:=-Os -pipe -mips32r2 -mtune=mips32r2 -fno-caller-saves
KERNEL_PATCHVER:=4.9
BOARD_CPPFLAGS:=-D__MT7628__

define Target/Description
	Build firmware image for MT7628 based boards
endef

# include the profiles
include $(INCLUDE_DIR)/target.mk

DEFAULT_PACKAGES+=kmod-rtsoc_eth kmod-mips-wdt

$(eval $(call BuildTarget))

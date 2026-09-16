#
# Copyright (C) 2021 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

ARCH:=mipsel
BOARD:=mt7621
DESCRIPTION:=MediaTek MT7621
FEATURES:=squashfs hwnat
CFLAGS:=-O2 -pipe -mips32r2 -mtune=1004kc
KERNEL_PATCHVER:=4.9
BOARD_CPPFLAGS:=-D__MT7621__

define Target/Description
	Build firmware image for MT7621 based boards
endef

# include the profiles
include $(INCLUDE_DIR)/target.mk

DEFAULT_PACKAGES+=kmod-mt7621_eth kmod-mips-wdt

$(eval $(call BuildTarget))

#
# Copyright (C) 2023 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

ARCH:=aarch64
BOARD:=mt7981
DESCRIPTION:=MediaTek MT7981
FEATURES:=squashfs hwnat hwnat_mib usbuas
CFLAGS:=-O2 -pipe -fsigned-char -mcpu=cortex-a53
KERNEL_PATCHVER:=4.9
BOARD_CPPFLAGS:=-D__MT7981__

define Target/Description
	Build firmware image for MT7981 based boards
endef

# include the profiles
include $(INCLUDE_DIR)/target.mk

DEFAULT_PACKAGES+=kmod-mt7986_eth kmod-mt-wdt

$(eval $(call BuildTarget))

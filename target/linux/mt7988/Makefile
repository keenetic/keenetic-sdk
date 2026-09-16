#
# Copyright (C) 2024 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

ARCH:=aarch64
BOARD:=mt7988
DESCRIPTION:=MediaTek MT7988
FEATURES:=squashfs hwnat hwnat_mib usbuas
CFLAGS:=-O2 -pipe -fsigned-char -mcpu=cortex-a73
KERNEL_PATCHVER:=4.9
BOARD_CPPFLAGS:=-D__MT7988__

define Target/Description
	Build firmware image for MT7988A/D based boards
endef

# include the profiles
include $(INCLUDE_DIR)/target.mk

DEFAULT_PACKAGES+=kmod-mt7988_eth kmod-mt-wdt

$(eval $(call BuildTarget))

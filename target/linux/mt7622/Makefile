#
# Copyright (C) 2021 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

ARCH:=aarch64
BOARD:=mt7622
DESCRIPTION:=MediaTek MT7622
FEATURES:=squashfs usb usbstorage extended_storage hwnat hwnat_mib
CFLAGS:=-O2 -pipe -fsigned-char -mcpu=cortex-a53
KERNEL_PATCHVER:=4.9
BOARD_CPPFLAGS:=-D__MT7622__

define Target/Description
	Build firmware image for MT7622 based boards
endef

# include the profiles
include $(INCLUDE_DIR)/target.mk

DEFAULT_PACKAGES+=kmod-mt7622_eth kmod-mt-wdt

$(eval $(call BuildTarget))

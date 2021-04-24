#
# Copyright (C) 2021 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

ARCH:=mips
BOARD:=en7516
DESCRIPTION:=EcoNet EN7516
FEATURES:=squashfs usb usbstorage extended_storage hwnat
CFLAGS:=-O2 -pipe -mips32r2 -mtune=1004kc
BOARD_CPPFLAGS:=-D__EN7516__
KERNEL_PATCHVER:=4.9

define Target/Description
	Build firmware image for EN7516 based boards
endef

# include the profiles
include $(INCLUDE_DIR)/target.mk

DEFAULT_PACKAGES+=kmod-ensoc_eth kmod-mips-wdt

$(eval $(call BuildTarget))

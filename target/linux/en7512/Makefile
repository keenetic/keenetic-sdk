#
# Copyright (C) 2021 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

ARCH:=mips
BOARD:=en7512
DESCRIPTION:=EcoNet EN7512
FEATURES:=squashfs usb usbstorage hwnat
CFLAGS:=-O2 -pipe -mips32r2 -mtune=34kc
BOARD_CPPFLAGS:=-D__EN7512__
KERNEL_PATCHVER:=4.9

define Target/Description
	Build firmware image for EN7512 based boards
endef

# include the profiles
include $(INCLUDE_DIR)/target.mk

DEFAULT_PACKAGES+=kmod-ensoc_eth kmod-mips-wdt

$(eval $(call BuildTarget))

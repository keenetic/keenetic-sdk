#
# Copyright (C) 2021 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

ARCH:=mipsel
BOARD:=en7528
DESCRIPTION:=EcoNet EN7528DU/EN7561DU
FEATURES:=squashfs hwnat
CFLAGS:=-O2 -pipe -mips32r2 -mtune=1004kc
BOARD_CPPFLAGS:=-D__EN7528__
KERNEL_PATCHVER:=4.9

define Target/Description
	Build firmware image for EN7528DU/EN7561DU based boards
endef

# include the profiles
include $(INCLUDE_DIR)/target.mk

DEFAULT_PACKAGES+=kmod-ensoc_eth kmod-mips-wdt

$(eval $(call BuildTarget))

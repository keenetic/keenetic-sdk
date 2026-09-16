#
# Copyright (C) 2026 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=mt7988_eth
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define KernelPackage/mt7988_eth
  SUBMENU:=Network Devices
  CATEGORY:=Kernel modules
  TITLE:=Ethernet switch driver for MediaTek MT7987/8
  DEPENDS:=@TARGET_mt7987||TARGET_mt7988 +kmod-phr
  DISABLE_RSTRIP:=y
endef

define KernelPackage/mt7988_eth/install
	if [ -d ./files-mt7988_eth ]; then \
		$(CP) ./files-mt7988_eth/* $(1); \
	fi
endef

$(eval $(call KernelPackage,mt7988_eth))

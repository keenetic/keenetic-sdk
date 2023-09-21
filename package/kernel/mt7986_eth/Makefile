#
# Copyright (C) 2023 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=mt7986_eth
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define KernelPackage/mt7986_eth
  SUBMENU:=Network Devices
  CATEGORY:=Kernel modules
  TITLE:=Ethernet switch driver for MediaTek MT7981/MT7986
  DEPENDS:=@TARGET_mt7981||TARGET_mt7986
  DISABLE_RSTRIP:=y
endef

define KernelPackage/mt7986_eth/install
	if [ -d ./files-mt7986_eth ]; then \
		$(CP) ./files-mt7986_eth/* $(1); \
	fi
endef

$(eval $(call KernelPackage,mt7986_eth))

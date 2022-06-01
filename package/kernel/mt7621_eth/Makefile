#
# Copyright (C) 2022 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=mt7621_eth
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define KernelPackage/mt7621_eth
  SUBMENU:=Network Devices
  CATEGORY:=Kernel modules
  TITLE:=Ethernet switch driver for MediaTek MT7621
  DEPENDS:=@TARGET_mt7621
  DISABLE_RSTRIP:=y
endef

define KernelPackage/mt7621_eth/install
	if [ -d ./files-mt7621_eth ]; then \
		$(CP) ./files-mt7621_eth/* $(1); \
	fi
endef

$(eval $(call KernelPackage,mt7621_eth))

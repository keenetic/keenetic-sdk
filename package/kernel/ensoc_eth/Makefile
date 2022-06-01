#
# Copyright (C) 2022 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=ensoc_eth
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define KernelPackage/ensoc_eth
  SUBMENU:=Network Devices
  CATEGORY:=Kernel modules
  TITLE:=Ethernet switch driver for EcoNet EN75xx SoCs
  DISABLE_RSTRIP:=y
endef

define KernelPackage/ensoc_eth/install
	if [ -d ./files-ensoc_eth ]; then \
		$(CP) ./files-ensoc_eth/* $(1); \
	fi
endef

$(eval $(call KernelPackage,ensoc_eth))

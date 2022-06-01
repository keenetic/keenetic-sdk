#
# Copyright (C) 2022 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=rtsoc_eth
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define KernelPackage/rtsoc_eth
  SUBMENU:=Network Devices
  CATEGORY:=Kernel modules
  TITLE:=Ethernet switch driver for Ralink SoCs
  DISABLE_RSTRIP:=y
endef

define KernelPackage/rtsoc_eth/install
	if [ -d ./files-rtsoc_eth ]; then \
		$(CP) ./files-rtsoc_eth/* $(1); \
	fi
endef

$(eval $(call KernelPackage,rtsoc_eth))

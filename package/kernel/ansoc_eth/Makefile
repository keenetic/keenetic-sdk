#
# Copyright (C) 2026 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=ansoc_eth
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define KernelPackage/ansoc_eth
  SUBMENU:=Network Devices
  CATEGORY:=Kernel modules
  TITLE:=Ethernet switch driver for Airoha AN75xx ARM SoCs
  DEPENDS:=@TARGET_an7552||TARGET_an7581
  DISABLE_RSTRIP:=y
endef

define KernelPackage/ansoc_eth/install
	if [ -d ./files-ansoc_eth ]; then \
		$(CP) ./files-ansoc_eth/* $(1); \
	fi
endef

$(eval $(call KernelPackage,ansoc_eth))

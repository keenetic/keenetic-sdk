#
# Copyright (C) 2023 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=mt76x2
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define KernelPackage/mt76x2
  SUBMENU:=Wireless
  CATEGORY:=Kernel modules
  TITLE:=Wireless MediaTek MT7620/MT76x2 driver
  KCONFIG:=CONFIG_MT76X2_AP
  DEPENDS:=@HAS_MT76X2_RADIO +kmod-phr
  DISABLE_RSTRIP:=y
endef

define KernelPackage/mt76x2/install
	if [ -d ./files-mt76x2 ]; then \
		$(CP) ./files-mt76x2/* $(1); \
	fi
endef

$(eval $(call KernelPackage,mt76x2))

define KernelPackage/mt76x2-ate
  SUBMENU:=Wireless
  CATEGORY:=Kernel modules
  TITLE:=Wireless MediaTek MT7620/MT76x2 driver (ATE)
  KCONFIG:=CONFIG_MT76X2_AP
  DEPENDS:=@HAS_MT76X2_RADIO +kmod-phr
  DISABLE_RSTRIP:=y
endef

define KernelPackage/mt76x2-ate/install
	if [ -d ./files-mt76x2-ate ]; then \
		$(CP) ./files-mt76x2-ate/* $(1); \
	fi
endef

$(eval $(call KernelPackage,mt76x2-ate))

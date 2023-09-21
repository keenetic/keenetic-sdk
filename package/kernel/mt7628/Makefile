#
# Copyright (C) 2023 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=mt7628
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define KernelPackage/mt7628
  SUBMENU:=Wireless
  CATEGORY:=Kernel modules
  TITLE:=Wireless MediaTek MT7628 driver
  KCONFIG:=CONFIG_MT7628_AP
  DEPENDS:=@HAS_MT7628_RADIO +kmod-phr
  DISABLE_RSTRIP:=y
endef

define KernelPackage/mt7628/install
	if [ -d ./files-mt7628 ]; then \
		$(CP) ./files-mt7628/* $(1); \
	fi
endef

$(eval $(call KernelPackage,mt7628))

define KernelPackage/mt7628-ate
  SUBMENU:=Wireless
  CATEGORY:=Kernel modules
  TITLE:=Wireless MediaTek MT7628 driver (ATE)
  KCONFIG:=CONFIG_MT7628_AP
  DEPENDS:=@HAS_MT7628_RADIO +kmod-phr
  DISABLE_RSTRIP:=y
endef

define KernelPackage/mt7628-ate/install
	if [ -d ./files-mt7628-ate ]; then \
		$(CP) ./files-mt7628-ate/* $(1); \
	fi
endef

$(eval $(call KernelPackage,mt7628-ate))

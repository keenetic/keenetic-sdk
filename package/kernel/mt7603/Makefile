#
# Copyright (C) 2023 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=mt7603
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define KernelPackage/mt7603
  SUBMENU:=Wireless
  CATEGORY:=Kernel modules
  TITLE:=Wireless MediaTek MT7603E/MT7592N driver
  KCONFIG:=CONFIG_MT7603_AP
  DEPENDS:=@HAS_MT7603_RADIO +kmod-phr
  DISABLE_RSTRIP:=y
endef

define KernelPackage/mt7603/install
	if [ -d ./files-mt7603 ]; then \
		$(CP) ./files-mt7603/* $(1); \
	fi
endef

$(eval $(call KernelPackage,mt7603))

define KernelPackage/mt7603-ate
  SUBMENU:=Wireless
  CATEGORY:=Kernel modules
  TITLE:=Wireless MediaTek MT7603E/MT7592N driver (ATE)
  KCONFIG:=CONFIG_MT7603_AP
  DEPENDS:=@HAS_MT7603_RADIO +kmod-phr
  DISABLE_RSTRIP:=y
endef

define KernelPackage/mt7603-ate/install
	if [ -d ./files-mt7603-ate ]; then \
		$(CP) ./files-mt7603-ate/* $(1); \
	fi
endef

$(eval $(call KernelPackage,mt7603-ate))

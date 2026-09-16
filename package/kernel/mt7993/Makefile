#
# Copyright (C) 2026 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=mt7993
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define KernelPackage/mt7993
  SUBMENU:=Wireless
  CATEGORY:=Kernel modules
  TITLE:=Wireless MediaTek MT7993 Eagle/Kite/Griffin driver
  KCONFIG:=CONFIG_MT7993_AP CONFIG_FW_LOADER=y
  DEPENDS:=@HAS_MT7993_RADIO +kmod-phr
  DISABLE_RSTRIP:=y
endef

define Package/mt7993/config
	source "package/kernel/mt7993/Config.in"
endef

define KernelPackage/mt7993/install
	if [ -d ./files-mt7993 ]; then \
		$(CP) ./files-mt7993/* $(1); \
	fi
endef

$(eval $(call KernelPackage,mt7993))

define KernelPackage/mt7993-ate
  SUBMENU:=Wireless
  CATEGORY:=Kernel modules
  TITLE:=Wireless MediaTek MT7993 Eagle/Kite/Griffin driver (ATE)
  KCONFIG:=CONFIG_MT7993_AP CONFIG_FW_LOADER=y
  DEPENDS:=@HAS_MT7993_RADIO +kmod-phr
  DISABLE_RSTRIP:=y
endef

define KernelPackage/mt7993-ate/install
	if [ -d ./files-mt7993-ate ]; then \
		$(CP) ./files-mt7993-ate/* $(1); \
	fi
endef

$(eval $(call KernelPackage,mt7993-ate))

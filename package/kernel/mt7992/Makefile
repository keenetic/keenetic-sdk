#
# Copyright (C) 2026 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=mt7992
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define KernelPackage/mt7992
  SUBMENU:=Wireless
  CATEGORY:=Kernel modules
  TITLE:=Wireless MediaTek MT7992 Eagle/Kite driver
  KCONFIG:=CONFIG_MT7992_AP CONFIG_FW_LOADER=y
  DEPENDS:=@HAS_MT7992_RADIO +kmod-phr
  DISABLE_RSTRIP:=y
endef

define Package/mt7992/config
	source "package/kernel/mt7992/Config.in"
endef

define KernelPackage/mt7992/install
	if [ -d ./files-mt7992 ]; then \
		$(CP) ./files-mt7992/* $(1); \
	fi
endef

$(eval $(call KernelPackage,mt7992))

define KernelPackage/mt7992-ate
  SUBMENU:=Wireless
  CATEGORY:=Kernel modules
  TITLE:=Wireless MediaTek MT7992 Eagle/Kite driver (ATE)
  KCONFIG:=CONFIG_MT7992_AP CONFIG_FW_LOADER=y
  DEPENDS:=@HAS_MT7992_RADIO +kmod-phr
  DISABLE_RSTRIP:=y
endef

define KernelPackage/mt7992-ate/install
	if [ -d ./files-mt7992-ate ]; then \
		$(CP) ./files-mt7992-ate/* $(1); \
	fi
endef

$(eval $(call KernelPackage,mt7992-ate))

#
# Copyright (C) 2022 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=mt7610
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define KernelPackage/mt7610
  SUBMENU:=Wireless
  CATEGORY:=Kernel modules
  TITLE:=Wireless MediaTek MT7610 driver
  KCONFIG:=CONFIG_MT7610_AP
  DEPENDS:=@HAS_MT7610_RADIO +kmod-phr
  DISABLE_RSTRIP:=y
endef

define KernelPackage/mt7610/install
	if [ -d ./files-mt7610 ]; then \
		$(CP) ./files-mt7610/* $(1); \
	fi
endef

$(eval $(call KernelPackage,mt7610))

define KernelPackage/mt7610-ate
  SUBMENU:=Wireless
  CATEGORY:=Kernel modules
  TITLE:=Wireless MediaTek MT7610 driver (ATE)
  KCONFIG:=CONFIG_MT7610_AP
  DEPENDS:=@HAS_MT7610_RADIO +kmod-phr
  DISABLE_RSTRIP:=y
endef

define KernelPackage/mt7610-ate/install
	if [ -d ./files-mt7610-ate ]; then \
		$(CP) ./files-mt7610-ate/* $(1); \
	fi
endef

$(eval $(call KernelPackage,mt7610-ate))

#
# Copyright (C) 2022 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=mt7613
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define KernelPackage/mt7613
  SUBMENU:=Wireless
  CATEGORY:=Kernel modules
  TITLE:=Wireless MediaTek MT7613E/MT7663E driver
  KCONFIG:=CONFIG_MT7613_AP CONFIG_FW_LOADER=y
  DEPENDS:=@HAS_MT7613_RADIO +kmod-phr
  DISABLE_RSTRIP:=y
endef

define KernelPackage/mt7613/install
	if [ -d ./files-mt7613 ]; then \
		$(CP) ./files-mt7613/* $(1); \
	fi
endef

$(eval $(call KernelPackage,mt7613))

define KernelPackage/mt7613-ate
  SUBMENU:=Wireless
  CATEGORY:=Kernel modules
  TITLE:=Wireless MediaTek MT7613E/MT7663E driver (ATE)
  KCONFIG:=CONFIG_MT7613_AP CONFIG_FW_LOADER=y
  DEPENDS:=@HAS_MT7613_RADIO +kmod-phr
  DISABLE_RSTRIP:=y
endef

define KernelPackage/mt7613-ate/install
	if [ -d ./files-mt7613-ate ]; then \
		$(CP) ./files-mt7613-ate/* $(1); \
	fi
endef

$(eval $(call KernelPackage,mt7613-ate))

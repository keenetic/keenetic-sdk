#
# Copyright (C) 2023 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=mt7916
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define KernelPackage/mt7916
  SUBMENU:=Wireless
  CATEGORY:=Kernel modules
  TITLE:=Wireless MediaTek MT7916/MT7981/MT7986 driver
  KCONFIG:=CONFIG_MT7916_AP CONFIG_FW_LOADER=y
  DEPENDS:=@HAS_MT7916_RADIO +kmod-phr
  DISABLE_RSTRIP:=y
endef

define KernelPackage/mt7916/install
	if [ -d ./files-mt7916 ]; then \
		$(CP) ./files-mt7916/* $(1); \
	fi
endef

$(eval $(call KernelPackage,mt7916))

define KernelPackage/mt7916-ate
  SUBMENU:=Wireless
  CATEGORY:=Kernel modules
  TITLE:=Wireless MediaTek MT7916/MT7981/MT7986 driver (ATE)
  KCONFIG:=CONFIG_MT7916_AP CONFIG_FW_LOADER=y
  DEPENDS:=@HAS_MT7916_RADIO +kmod-phr
  DISABLE_RSTRIP:=y
endef

define KernelPackage/mt7916-ate/install
	if [ -d ./files-mt7916-ate ]; then \
		$(CP) ./files-mt7916-ate/* $(1); \
	fi
endef

$(eval $(call KernelPackage,mt7916-ate))

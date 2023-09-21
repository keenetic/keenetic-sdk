#
# Copyright (C) 2023 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=mt7915
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define KernelPackage/mt7915
  SUBMENU:=Wireless
  CATEGORY:=Kernel modules
  TITLE:=Wireless MediaTek MT7915 driver
  KCONFIG:=CONFIG_MT7915_AP CONFIG_FW_LOADER=y
  DEPENDS:=@HAS_MT7915_RADIO +kmod-phr
  DISABLE_RSTRIP:=y
endef

define KernelPackage/mt7915/install
	if [ -d ./files-mt7915 ]; then \
		$(CP) ./files-mt7915/* $(1); \
	fi
endef

$(eval $(call KernelPackage,mt7915))

define KernelPackage/mt7915-ate
  SUBMENU:=Wireless
  CATEGORY:=Kernel modules
  TITLE:=Wireless MediaTek MT7915 driver (ATE)
  KCONFIG:=CONFIG_MT7915_AP CONFIG_FW_LOADER=y
  DEPENDS:=@HAS_MT7915_RADIO +kmod-phr
  DISABLE_RSTRIP:=y
endef

define KernelPackage/mt7915-ate/install
	if [ -d ./files-mt7915-ate ]; then \
		$(CP) ./files-mt7915-ate/* $(1); \
	fi
endef

$(eval $(call KernelPackage,mt7915-ate))

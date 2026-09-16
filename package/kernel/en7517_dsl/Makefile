#
# Copyright (C) 2026 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=en7517_dsl
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define KernelPackage/en7517_dsl
  SUBMENU:=Network Support
  CATEGORY:=Kernel modules
  TITLE:=xDSL drivers for Airoha EN7517 chip
  KCONFIG:=CONFIG_FW_LOADER=y
  DEPENDS:=@TARGET_mt7981||TARGET_mt7988 +kmod-phr
  DISABLE_RSTRIP:=y
endef

define KernelPackage/en7517_dsl/install
	if [ -d ./files-en7517_dsl ]; then \
		$(CP) ./files-en7517_dsl/* $(1); \
	fi
endef

$(eval $(call KernelPackage,en7517_dsl))

#
# Copyright (C) 2023 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=mtk-crypto
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define KernelPackage/mtk-crypto
  SUBMENU:=Cryptographic API modules
  CATEGORY:=Kernel modules
  TITLE:=MTK crypto driver for EN7512 / EN7516 / EN7528 / MT7621
  KCONFIG:=CONFIG_RALINK_HWCRYPTO
  DEPENDS:=@TARGET_mt7621||TARGET_en7512||TARGET_en7516||TARGET_en7528 +kmod-crypto-manager +kmod-ipsec
  DISABLE_RSTRIP:=y
endef

define KernelPackage/mtk-crypto/install
	if [ -d ./files-mtk-crypto ]; then \
		$(CP) ./files-mtk-crypto/* $(1); \
	fi
endef

$(eval $(call KernelPackage,mtk-crypto))

#
# Copyright (C) 2023 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=mtk-aes-engine
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define KernelPackage/mtk-aes-engine
  SUBMENU:=Cryptographic API modules
  CATEGORY:=Kernel modules
  TITLE:=MTK AES crypto driver for MT7268
  DEPENDS:=@TARGET_mt7628
  DISABLE_RSTRIP:=y
endef

define KernelPackage/mtk-aes-engine/install
	if [ -d ./files-mtk-aes-engine ]; then \
		$(CP) ./files-mtk-aes-engine/* $(1); \
	fi
endef

$(eval $(call KernelPackage,mtk-aes-engine))

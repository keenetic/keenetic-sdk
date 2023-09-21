#
# Copyright (C) 2023 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=eip93-cryptoapi
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define KernelPackage/eip93-cryptoapi
  SUBMENU:=Cryptographic API modules
  CATEGORY:=Kernel modules
  TITLE:=EIP93 CryptoAPI driver for EN7512 / EN7516 / EN7528 / MT7621
  DEPENDS:=@TARGET_mt7621||TARGET_en7512||TARGET_en7516||TARGET_en7528 +kmod-crypto-manager +kmod-crypto-aes +kmod-crypto-arc4 +kmod-crypto-authenc +kmod-crypto-cbc +kmod-crypto-des +kmod-crypto-ecb +kmod-crypto-echainiv +kmod-crypto-seqiv +kmod-crypto-hmac +kmod-crypto-iv +kmod-crypto-md5 +kmod-crypto-sha1 +kmod-crypto-sha256
  DISABLE_RSTRIP:=y
endef

define KernelPackage/eip93-cryptoapi/install
	if [ -d ./files-eip93-cryptoapi ]; then \
		$(CP) ./files-eip93-cryptoapi/* $(1); \
	fi
endef

$(eval $(call KernelPackage,eip93-cryptoapi))

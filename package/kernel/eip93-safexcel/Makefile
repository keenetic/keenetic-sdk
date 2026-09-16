#
# Copyright (C) 2026 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=eip93-safexcel
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define KernelPackage/eip93-safexcel
  SUBMENU:=Cryptographic API modules
  CATEGORY:=Kernel modules
  TITLE:=Inside Secure SafeXcel EIP-93 crypto engine driver
  KCONFIG:=CONFIG_CRYPTO_DEV_EIP93 CONFIG_CRYPTO_DEV_EIP93_DES
  DEPENDS:=@TARGET_an7552||TARGET_an7581 +kmod-crypto-manager +kmod-crypto-aes +kmod-crypto-authenc +kmod-crypto-cbc +kmod-crypto-des +kmod-crypto-ecb +kmod-crypto-hash +kmod-crypto-hmac +kmod-crypto-md5 +kmod-crypto-sha1 +kmod-crypto-sha256
  DISABLE_RSTRIP:=y
endef

define KernelPackage/eip93-safexcel/install
	if [ -d ./files-eip93-safexcel ]; then \
		$(CP) ./files-eip93-safexcel/* $(1); \
	fi
endef

$(eval $(call KernelPackage,eip93-safexcel))

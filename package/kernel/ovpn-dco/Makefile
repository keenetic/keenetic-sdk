#
# Copyright (C) 2023 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=ovpn-dco
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define KernelPackage/ovpn-dco
  SUBMENU:=Network Support
  CATEGORY:=Kernel modules
  TITLE:=OpenVPN DCO driver
  DEPENDS:=+kmod-crypto-manager +kmod-crypto-aes +kmod-crypto-authenc +kmod-crypto-cbc +kmod-crypto-des +kmod-crypto-ecb +kmod-crypto-echainiv +kmod-crypto-seqiv +kmod-crypto-hmac +kmod-crypto-iv +kmod-crypto-md5 +kmod-crypto-sha1 +kmod-crypto-sha256 +kmod-crypto-gcm +kmod-crypto-chacha20poly1305 +kmod-udptunnel6 +kmod-udptunnel4
  DISABLE_RSTRIP:=y
endef

define KernelPackage/ovpn-dco/install
	if [ -d ./files-ovpn-dco ]; then \
		$(CP) ./files-ovpn-dco/* $(1); \
	fi
endef

$(eval $(call KernelPackage,ovpn-dco))

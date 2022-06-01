#
# Copyright (C) 2014 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=cryptodev-linux
PKG_VERSION:=1.10

PKG_SOURCE_URL:=https://codeload.github.com/$(PKG_NAME)/$(PKG_NAME)/tar.gz/$(PKG_NAME)-$(PKG_VERSION)?
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_HASH:=833ab7c5c88d2b700a7c702a151254c089a3058886a63cc7d12630e364b8ea83
PKG_LICENSE:=GPL-2.0
PKG_LICENSE_FILES:=COPYING

PKG_BUILD_DIR:=$(KERNEL_BUILD_DIR)/$(PKG_NAME)-$(PKG_NAME)-$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/ndm-build.mk

define KernelPackage/$(PKG_NAME)
	SUBMENU:=Cryptographic API modules
	URL:=http://cryptodev-linux.org/
	DEPENDS:=+kmod-crypto-authenc +kmod-crypto-hash
	TITLE:=BSD's cryptodev kernel module
	FILES:=$(PKG_BUILD_DIR)/cryptodev.ko
endef

define Build/Configure
endef

define Build/Compile
	+$(KERNEL_MAKE) $(PKG_JOBS) \
		-C $(PKG_BUILD_DIR) \
		KERNEL_DIR="$(LINUX_DIR)"
endef

define Build/InstallDev
	$(INSTALL_DIR) $(STAGING_DIR)/usr/include/crypto
	$(CP) $(PKG_BUILD_DIR)/crypto/cryptodev.h $(STAGING_DIR)/usr/include/crypto/
endef

$(eval $(call KernelPackage,$(PKG_NAME)))

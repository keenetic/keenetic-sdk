#
# Copyright (C) 2021 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=node
PKG_VERSION:=14.19.3

PKG_ARCH:=linux-x64
PKG_SOURCE:=$(PKG_NAME)-v$(PKG_VERSION)-$(PKG_ARCH).tar.xz
PKG_SOURCE_URL:=https://nodejs.org/dist/v$(PKG_VERSION)
PKG_HASH:=fe10b10f6164df733c14db4e28c9f0686e5f54eb3ebc6e4577a2e5e9dafcc6a0

HOST_BUILD_DIR:=$(BUILD_DIR_HOST)/$(PKG_NAME)-v$(PKG_VERSION)-$(PKG_ARCH)

include $(INCLUDE_DIR)/host-build.mk

define Host/Compile
endef

define Host/Install
	$(INSTALL_DIR) $(STAGING_DIR_HOST)/{bin,lib}
	$(CP) $(HOST_BUILD_DIR)/bin/{node,npm,npx} $(STAGING_DIR_HOST)/bin/
	$(CP) $(HOST_BUILD_DIR)/lib/node_modules $(STAGING_DIR_HOST)/lib/
endef

define Host/Clean
endef

$(eval $(call HostBuild))

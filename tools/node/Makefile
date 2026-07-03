#
# Copyright (C) 2021 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=node
PKG_VERSION:=22.18.0

PKG_ARCH:=linux-x64
ifeq ($(HOST_ARCH),aarch64)
  PKG_ARCH:=linux-arm64
endif

PKG_SOURCE:=$(PKG_NAME)-v$(PKG_VERSION)-$(PKG_ARCH).tar.xz
PKG_SOURCE_URL:=https://nodejs.org/dist/v$(PKG_VERSION)

PKG_HASH:=c1bfeecf1d7404fa74728f9db72e697decbd8119ccc6f5a294d795756dfcfca7
ifeq ($(HOST_ARCH),aarch64)
  PKG_HASH:=04fca1b9afecf375f26b41d65d52aa1703a621abea5a8948c7d1e351e85edade
endif

HOST_BUILD_DIR:=$(BUILD_DIR_HOST)/$(PKG_NAME)-v$(PKG_VERSION)-$(PKG_ARCH)

include $(INCLUDE_DIR)/host-build.mk

define Host/Compile
	PATH=$(HOST_BUILD_DIR)/bin:$(PATH) corepack enable
endef

define Host/Install
	$(INSTALL_DIR) $(STAGING_DIR_HOST)/{bin,lib}
	$(CP) $(HOST_BUILD_DIR)/bin/{node,npm,npx,yarn} $(STAGING_DIR_HOST)/bin/
	$(CP) $(HOST_BUILD_DIR)/lib/node_modules $(STAGING_DIR_HOST)/lib/
endef

define Host/Clean
endef

$(eval $(call HostBuild))

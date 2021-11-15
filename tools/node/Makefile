#
# Copyright (C) 2021 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=node
PKG_VERSION:=14.17.6

PKG_ARCH:=linux-x64
PKG_SOURCE:=$(PKG_NAME)-v$(PKG_VERSION)-$(PKG_ARCH).tar.xz
PKG_SOURCE_URL:=https://nodejs.org/dist/v$(PKG_VERSION)
PKG_HASH:=3bbe4faf356738d88b45be222bf5e858330541ff16bd0d4cfad36540c331461b

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

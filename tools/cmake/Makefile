#
# Copyright (C) 2022 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=cmake
PKG_VERSION:=3.23.1

PKG_ARCH:=linux-x86_64
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_ARCH).tar.gz
PKG_SOURCE_URL:=https://github.com/Kitware/CMake/releases/download/v$(PKG_VERSION)
PKG_HASH:=f3c654b2e226b9d43369e0bd8487c51618d4dbe5a1af929dd32af7e6ca432d60

HOST_BUILD_DIR:=$(BUILD_DIR_HOST)/$(PKG_NAME)-$(PKG_VERSION)-$(PKG_ARCH)

include $(INCLUDE_DIR)/host-build.mk

define Host/Compile
endef

define Host/Install
	$(INSTALL_DIR) $(STAGING_DIR_HOST)/{bin,share}
	$(CP) $(HOST_BUILD_DIR)/bin/{cmake,cpack,ctest} $(STAGING_DIR_HOST)/bin/
	$(CP) $(HOST_BUILD_DIR)/share/cmake-* $(STAGING_DIR_HOST)/share/
endef

define Host/Clean
	$(Host/Clean/Default)
	rm -f $(STAGING_DIR_HOST)/bin/{cmake,cpack,ctest}
	rm -rf $(STAGING_DIR_HOST)/share/cmake-*
endef

$(eval $(call HostBuild))

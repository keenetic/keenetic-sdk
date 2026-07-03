#
# Copyright (C) 2022 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=cmake
PKG_VERSION:=3.31.8

PKG_ARCH:=linux-x86_64
ifeq ($(HOST_ARCH),aarch64)
  PKG_ARCH:=linux-aarch64
endif

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_ARCH).tar.gz
PKG_SOURCE_URL:=https://github.com/Kitware/CMake/releases/download/v$(PKG_VERSION)
PKG_HASH:=630615d8e98ac33eba7fbe472626dff5c899c85af3c024585ae109166a6909d0
ifeq ($(HOST_ARCH),aarch64)
  PKG_HASH:=609735983e3bdf24b6ab379d918458d64196fe72b98226f62dd5e9fe7b2997cc
endif

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

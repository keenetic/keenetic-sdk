#
# Copyright (C) 2021 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk

PKG_NAME:=zstd
PKG_VERSION:=1.5.7
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://github.com/facebook/zstd/releases/download/v$(PKG_VERSION)
PKG_HASH:=eb33e51f49a15e023950cd7825ca74a4a2b43db8354825ac24fc1b7ee09e6fa3

PKG_LICENSE:=BSD-3-Clause
PKG_LICENSE_FILES:=LICENSE

PKG_CONFIG_DEPENDS:=CONFIG_ZSTD_OPTIMIZE_SPEED

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/host-build.mk

define Package/zstd
  SECTION:=libs
  CATEGORY:=Libraries
  TITLE:=Zstandard library
  URL:=https://github.com/facebook/zstd
endef

define Package/zstd/description
  Zstandard is a fast lossless compression algorithm.
  This package provides libzstd library.
endef

define Package/zstd/config
	source "$(SOURCE)/Config.in"
endef

MAKE_FLAGS += \
	ZSTD_LEGACY_SUPPORT=0 \
	$(if $(CONFIG_ZSTD_OPTIMIZE_SPEED),,ZSTD_LIB_MINIFY=1)

TARGET_CFLAGS:=$(filter-out -O%,$(TARGET_CFLAGS))

define Build/Compile
	$(call Build/Compile/Default,lib-release)
endef

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include
	$(CP) $(PKG_BUILD_DIR)/lib/zstd.h $(1)/usr/include
	$(CP) $(PKG_BUILD_DIR)/lib/zstd_errors.h $(1)/usr/include
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_BUILD_DIR)/lib/libzstd.a $(1)/usr/lib
endef

HOST_MAKE_FLAGS += \
	CC="$(HOSTCC)" \
	ZSTD_LEGACY_SUPPORT=0

HOST_CFLAGS:=$(filter-out -O%,$(HOST_CFLAGS))

define Host/Compile
	$(call Host/Compile/Default,lib-release)
endef

define Host/Install
	$(INSTALL_DIR) $(STAGING_DIR_HOST)/lib
	$(CP) $(HOST_BUILD_DIR)/lib/libzstd.a $(STAGING_DIR_HOST)/lib
	$(CP) $(HOST_BUILD_DIR)/lib/libzstd.so.$(PKG_VERSION) $(STAGING_DIR_HOST)/lib
	$(LN) libzstd.so.$(PKG_VERSION) $(STAGING_DIR_HOST)/lib/libzstd.so
	$(LN) libzstd.so.$(PKG_VERSION) $(STAGING_DIR_HOST)/lib/libzstd.so.1
	$(INSTALL_DIR) $(STAGING_DIR_HOST)/include
	$(INSTALL_DATA) $(HOST_BUILD_DIR)/lib/zstd.h $(STAGING_DIR_HOST)/include/
endef

$(eval $(call BuildPackage,zstd))
$(eval $(call HostBuild))

#
# Copyright (C) 2014 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=nettle
PKG_VERSION:=3.10.1
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=@GNU/nettle
PKG_HASH:=b0fcdd7fc0cdea6e80dcf1dd85ba794af0d5b4a57e26397eee3bc193272d9132

PKG_LICENSE:=GPL-2.0-or-later
PKG_LICENSE_FILES:=COPYINGv2
PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk

define Package/libnettle
  SECTION:=libs
  CATEGORY:=Libraries
  TITLE:=GNU crypto library
  URL:=http://www.lysator.liu.se/~nisse/nettle/
endef

TARGET_CFLAGS += $(FPIC)

CONFIGURE_ARGS += \
	--enable-shared \
	--enable-fat \
	--enable-openssl \
	--disable-documentation \
	--enable-static \
	--enable-mini-gmp \
	--disable-assembler

define Build/Compile
	$(call Build/Compile/Default, \
		DESTDIR="$(PKG_INSTALL_DIR)" \
		CC="$(TARGET_CC)" \
		libnettle.so libhogweed.so
	+$(MAKE) -i $(PKG_JOBS) -C $(PKG_BUILD_DIR) \
		DESTDIR="$(PKG_INSTALL_DIR)" \
		install)
endef

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include/nettle
	$(CP) $(PKG_INSTALL_DIR)/usr/include/nettle/*.h $(1)/usr/include/nettle/
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libnettle.{a,so*} $(1)/usr/lib/
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libhogweed.{a,so*} $(1)/usr/lib/
	$(INSTALL_DIR) $(1)/usr/lib/pkgconfig
	$(CP) \
		$(PKG_INSTALL_DIR)/usr/lib/pkgconfig/nettle.pc \
		$(PKG_INSTALL_DIR)/usr/lib/pkgconfig/hogweed.pc \
		$(1)/usr/lib/pkgconfig/
endef

define Package/libnettle/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libnettle.so.* $(1)/usr/lib/
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libhogweed.so.* $(1)/usr/lib/
endef

$(eval $(call BuildPackage,libnettle))

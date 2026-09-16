#
# Copyright (C) 2014 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=libarchive
PKG_VERSION:=3.5.2
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.xz
PKG_SOURCE_URL:=https://www.libarchive.org/downloads
PKG_HASH:=f0b19ff39c3c9a5898a219497ababbadab99d8178acc980155c7e1271089b5a0

PKG_MAINTAINER:=Johannes Morgenroth <morgenroth@ibr.cs.tu-bs.de>
PKG_LICENSE:=BSD-2-Clause
PKG_LICENSE_FILES:=COPYING
PKG_CPE_ID:=cpe:/a:libarchive:libarchive

HOST_BUILD_DEPENDS:=zstd/host

PKG_INSTALL:=1

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/host-build.mk

define Package/libarchive
  SECTION:=libs
  CATEGORY:=Libraries
  DEPENDS:=+zlib
  TITLE:=Multi-format archive and compression library
  URL:=https://www.libarchive.org/
endef

CONFIGURE_ARGS+= \
	--disable-bsdtar \
	--disable-bsdcat \
	--disable-bsdcpio \
	--disable-rpath \
	--disable-posix-regex-lib \
	--disable-acl \
	--without-bz2lib \
	--without-libb2 \
	--without-iconv \
	--without-lz4 \
	--without-zstd \
	--without-lzma \
	--without-cng \
	--without-openssl \
	--without-xml2 \
	--without-expat

HOST_CONFIGURE_ARGS+= \
	--enable-xattr \
	--disable-bsdtar \
	--disable-bsdcat \
	--disable-bsdcpio \
	--disable-rpath \
	--disable-posix-regex-lib \
	--disable-acl \
	--without-bz2lib \
	--without-libb2 \
	--without-iconv \
	--without-lz4 \
	--without-lzma \
	--without-cng \
	--without-openssl \
	--without-xml2 \
	--without-expat

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include
	$(CP) $(PKG_INSTALL_DIR)/usr/include/* $(1)/usr/include/
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/* $(1)/usr/lib/
endef

define Package/libarchive/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/*.so.* $(1)/usr/lib/
endef

$(eval $(call BuildPackage,libarchive))
$(eval $(call HostBuild))

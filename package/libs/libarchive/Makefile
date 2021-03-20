#
# Copyright (C) 2014 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=libarchive
PKG_VERSION:=3.4.3
PKG_RELEASE:=2

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.xz
PKG_SOURCE_URL:=https://www.libarchive.org/downloads
PKG_HASH:=0bfc3fd40491768a88af8d9b86bf04a9e95b6d41a94f9292dbc0ec342288c05f

PKG_MAINTAINER:=Johannes Morgenroth <morgenroth@ibr.cs.tu-bs.de>
PKG_LICENSE:=BSD-2-Clause
PKG_LICENSE_FILES:=COPYING
PKG_CPE_ID:=cpe:/a:libarchive:libarchive

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/host-build.mk

define Package/libarchive/Default
  SECTION:=libs
  CATEGORY:=Libraries
  DEPENDS:=+zlib +libexpat
  TITLE:=Multi-format archive and compression library
  URL:=https://www.libarchive.org/
endef

define Package/libarchive
  $(call Package/libarchive/Default)
endef

HOST_CONFIGURE_ARGS+= \
	--enable-xattr \
	--disable-bsdtar \
	--disable-bsdcat \
	--disable-bsdcpio \
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

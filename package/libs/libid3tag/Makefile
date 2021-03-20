#
# Copyright (C) 2006-2010 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=libid3tag
PKG_VERSION:=0.15.1b
PKG_RELEASE:=4

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=@SF/mad
PKG_HASH:=63da4f6e7997278f8a3fef4c6a372d342f705051d1eeb6a46a86b03610e26151

PKG_LICENSE_FILES:=COPYRIGHT COPYING

PKG_FIXUP:=autoreconf
PKG_INSTALL:=1

include $(INCLUDE_DIR)/package.mk

define Package/libid3tag
  SECTION:=libs
  CATEGORY:=Libraries
  DEPENDS:=+zlib
  TITLE:=An ID3 tag manipulation library
  URL:=https://www.underbit.com/products/mad/
endef

define Package/libid3tag/description
	libid3tag is a library for reading and (eventually) writing ID3 tags, both 
	ID3v1 and the various versions of ID3v2.
endef

EXTRA_CFLAGS   := $(FPIC)
EXTRA_CPPFLAGS := -D_FILE_OFFSET_BITS=64 \
                  -D_LARGEFILE_SOURCE \
                  -D_LARGEFILE64_SOURCE

define Build/Configure
	$(call Build/Configure/Default, \
		--disable-shared \
		--enable-static \
		--disable-debugging \
		--disable-profiling \
	)
endef

define Build/Compile
	$(call Build/Compile/Default,all)
endef

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include
	$(CP) $(PKG_INSTALL_DIR)/usr/include/id3tag.h $(1)/usr/include/
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libid3tag.a $(1)/usr/lib/
endef

$(eval $(call BuildPackage,libid3tag))

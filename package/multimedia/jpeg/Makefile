#
# Copyright (C) 2006-2012 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=jpeg
PKG_VERSION:=6b
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)src.v$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=http://www.ijg.org/files/ \
        ftp://ftp.uu.net/graphics/jpeg/
PKG_HASH:=75c3ec241e9996504fe02a9ed4d12f16b74ade713972f3db9e65ce95cd27e35d

PKG_BUILD_DEPENDS:=libltdl

PKG_LICENSE:=FREE
PKG_LICENSE_FILES:=README

include $(INCLUDE_DIR)/host-build.mk
include $(INCLUDE_DIR)/package.mk

define Package/jpeg/Default
  TITLE:=The Independent JPEG Group's JPEG
  URL:=http://www.ijg.org/
endef

define Package/libjpeg
  $(call Package/jpeg/Default)
  SECTION:=libs
  CATEGORY:=Libraries
  TITLE+= runtime library
endef

EXTRA_CFLAGS   := $(FPIC)

CONFIGURE_ARGS += \
	--disable-shared \
	--enable-static \

HOST_CONFIGURE_ARGS += \
	--disable-shared \
	--enable-static \

define Build/Prepare
	$(call Build/Prepare/Default)
	(cd $(PKG_BUILD_DIR); \
		rm -f ltconfig ltmain.sh libtool; \
		ln -s `which true` ltconfig; \
		ln -s $(STAGING_DIR)/host/bin/libtool libtool; \
	)
endef

define Build/Compile
	$(INSTALL_DIR) $(PKG_INSTALL_DIR)/usr/{include,lib,bin,man/man1}
	+$(MAKE) $(PKG_JOBS) -C $(PKG_BUILD_DIR) \
		LIBTOOL="./libtool --tag=CC" \
		prefix="$(PKG_INSTALL_DIR)/usr" \
		exec_prefix="$(PKG_INSTALL_DIR)/usr" \
		all
	$(MAKE) -C $(PKG_BUILD_DIR) \
		prefix="$(PKG_INSTALL_DIR)/usr" \
		exec_prefix="$(PKG_INSTALL_DIR)/usr" \
		install install-headers install-lib
endef

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include
	$(CP) $(PKG_INSTALL_DIR)/usr/include/jpeglib.h $(1)/usr/include/
	$(CP) $(PKG_BUILD_DIR)/jpegint.h $(1)/usr/include/
	$(CP) $(PKG_INSTALL_DIR)/usr/include/j{config,error,morecfg}.h $(1)/usr/include/
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libjpeg.a $(1)/usr/lib/
endef

$(eval $(call HostBuild))
$(eval $(call BuildPackage,libjpeg))

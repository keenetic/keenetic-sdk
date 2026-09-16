include $(TOPDIR)/rules.mk

PKG_NAME:=libxml2
PKG_VERSION:=2.14.5
PKG_RELEASE:=2

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.xz
PKG_SOURCE_URL:=@GNOME/libxml2/$(basename $(PKG_VERSION))
PKG_HASH:=03d006f3537616833c16c53addcdc32a0eb20e55443cba4038307e3fa7d8d44b

PKG_LICENSE:=MIT
PKG_LICENSE_FILES:=Copyright
PKG_CPE_ID:=cpe:/a:xmlsoft:libxml2

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/libxml2
  SECTION:=libs
  CATEGORY:=Libraries
  TITLE:=Gnome XML library
  URL:=http://xmlsoft.org/
  DEPENDS:=+libpthread +zlib
endef

define Package/libxml2/description
 A library for manipulating XML and HTML resources.
endef

define Package/libxml2-dev
  SECTION:=devel
  CATEGORY:=Development
  SUBMENU:=Libraries
  TITLE:=Development files for libxml2
  URL:=http://xmlsoft.org/
  DEPENDS:=+libxml2
endef

define Package/libxml2-dev/description
  A library for manipulating XML and HTML resources.

  This package contains the headers and xml2-config binary.
endef

CMAKE_OPTIONS += \
	-DBUILD_SHARED_LIBS=ON \
	-DLIBXML2_WITH_C14N=OFF \
	-DLIBXML2_WITH_CATALOG=OFF \
	-DLIBXML2_WITH_DEBUG=OFF \
	-DLIBXML2_WITH_FTP=OFF \
	-DLIBXML2_WITH_HTML=ON \
	-DLIBXML2_WITH_HTTP=OFF \
	-DLIBXML2_WITH_ICONV=OFF \
	-DLIBXML2_WITH_ICU=OFF \
	-DLIBXML2_WITH_ISO8859X=OFF \
	-DLIBXML2_WITH_LEGACY=OFF \
	-DLIBXML2_WITH_LZMA=OFF \
	-DLIBXML2_WITH_MEM_DEBUG=OFF \
	-DLIBXML2_WITH_MODULES=OFF \
	-DLIBXML2_WITH_OUTPUT=ON \
	-DLIBXML2_WITH_PATTERN=OFF \
	-DLIBXML2_WITH_PROGRAMS=OFF \
	-DLIBXML2_WITH_PUSH=ON \
	-DLIBXML2_WITH_PYTHON=OFF \
	-DLIBXML2_WITH_READER=OFF \
	-DLIBXML2_WITH_REGEXPS=OFF \
	-DLIBXML2_WITH_RUN_DEBUG=OFF \
	-DLIBXML2_WITH_SAX1=OFF \
	-DLIBXML2_WITH_SCHEMAS=OFF \
	-DLIBXML2_WITH_SCHEMATRON=OFF \
	-DLIBXML2_WITH_TESTS=OFF \
	-DLIBXML2_WITH_THREADS=ON \
	-DLIBXML2_WITH_THREAD_ALLOC=OFF \
	-DLIBXML2_WITH_TREE=ON \
	-DLIBXML2_WITH_VALID=OFF \
	-DLIBXML2_WITH_WRITER=OFF \
	-DLIBXML2_WITH_XINCLUDE=OFF \
	-DLIBXML2_WITH_XPATH=OFF \
	-DLIBXML2_WITH_XPTR=OFF \
	-DLIBXML2_WITH_XPTR_LOCS=OFF \
	-DLIBXML2_WITH_ZLIB=ON \
	-DHAVE_LIBHISTORY=OFF \
	-DHAVE_LIBREADLINE=OFF

define Build/InstallDev
	$(INSTALL_DIR) $(2)/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/xml2-config \
		$(2)/bin/$(GNU_TARGET_NAME)-xml2-config
	$(SED) 's,^\(prefix\|exec_prefix\)=.*,\1=$(STAGING_DIR)/usr,g' \
		$(2)/bin/$(GNU_TARGET_NAME)-xml2-config
	$(LN) $(GNU_TARGET_NAME)-xml2-config $(2)/bin/xml2-config

	$(INSTALL_DIR) $(1)/usr/include
	$(CP) $(PKG_INSTALL_DIR)/usr/include/libxml2 $(1)/usr/include/

	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libxml2.so* $(1)/usr/lib/

	$(INSTALL_DIR) $(1)/usr/lib/cmake/libxml2
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/cmake/libxml2-$(PKG_VERSION)/*.cmake \
		$(1)/usr/lib/cmake/libxml2

	$(INSTALL_DIR) $(1)/usr/lib/pkgconfig
	$(INSTALL_DATA) $(PKG_INSTALL_DIR)/usr/lib/pkgconfig/libxml-2.0.pc $(1)/usr/lib/pkgconfig/
endef

define Package/libxml2/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libxml2.so.* $(1)/usr/lib/
endef

define Package/libxml2-dev/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(CP) $(PKG_INSTALL_DIR)/usr/bin/xml2-config $(1)/usr/bin/
	$(SED) "s,$(STAGING_DIR),,g" $(1)/usr/bin/xml2-config

	$(INSTALL_DIR) $(1)/usr/include/
	$(CP) $(PKG_INSTALL_DIR)/usr/include/* $(1)/usr/include/

	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libxml2.so $(1)/usr/lib/

	$(INSTALL_DIR) $(1)/usr/lib/{cmake,pkgconfig}
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/{cmake,pkgconfig} $(1)/usr/lib/
	$(SED) "s,$(STAGING_DIR),,g" $(1)/usr/lib/pkgconfig/*.pc
endef

$(eval $(call BuildPackage,libxml2))
$(eval $(call BuildPackage,libxml2-dev))

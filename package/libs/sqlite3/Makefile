#
# Copyright (C) 2006-2012 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=sqlite
PKG_VERSION:=3071502
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-autoconf-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=http://www.sqlite.org
PKG_HASH:=782d16b797f6ca879f6f679ba3fb6ceb54bcb0cab65feef332058bf04b36ba8c

PKG_LICENSE:=PUBLICDOMAIN
PKG_LICENSE_FILES:=

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-autoconf-$(PKG_VERSION)

PKG_FIXUP:=autoreconf

PKG_INSTALL:=1

include $(INCLUDE_DIR)/package.mk

define Package/sqlite3/Default
  TITLE:=SQLite (v3.x) database engine
  URL:=http://www.sqlite.org/
endef

define Package/sqlite3/Default/description
 SQLite is a small C library that implements a self-contained, embeddable,
 zero-configuration SQL database engine.
endef

define Package/libsqlite3
  $(call Package/sqlite3/Default)
  SECTION:=libs
  CATEGORY:=Libraries
  DEPENDS:=+libpthread
  TITLE+= (library)
endef

define Package/libsqlite3/description
$(call Package/sqlite3/Default/description)
 This package contains the SQLite (v3.x) shared library, used by other
 programs.
endef

define Package/sqlite3-cli
  $(call Package/sqlite3/Default)
  SECTION:=utils
  CATEGORY:=Utilities
  DEPENDS:=+libsqlite3
  TITLE+= (cli)
endef

define Package/sqlite3-cli/description
$(call Package/sqlite3/Default/description)
 This package contains a terminal-based front-end to the SQLite (v3.x) library
 that can evaluate queries interactively and display the results in multiple
 formats.
endef

TARGET_CFLAGS += $(FPIC) \
	-DSQLITE_ENABLE_UNLOCK_NOTIFY

CONFIGURE_ARGS += \
	--enable-shared \
	--disable-static \
	--disable-readline \
	--disable-dynamic-extensions \
	--disable-dependency-tracking

CONFIGURE_VARS += \
	config_BUILD_CC="$(HOSTCC)" \
	config_BUILD_CFLAGS="-Os" \
	config_TARGET_CC="$(TARGET_CC)" \
	config_TARGET_CFLAGS="$(TARGET_CFLAGS)" \
	config_TARGET_LDFLAGS="$(TARGET_LDFLAGS)" \
	config_TARGET_READLINE_INC="$(TARGET_CPPFLAGS)" \
	config_TARGET_READLINE_LIBS="$(TARGET_LDFLAGS)" \

define Build/Compile
	+$(MAKE) -C $(PKG_BUILD_DIR) \
	DESTDIR="$(PKG_INSTALL_DIR)" \
	all install
endef

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include
	$(CP) $(PKG_INSTALL_DIR)/usr/include/sqlite3{,ext}.h $(1)/usr/include/
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libsqlite3.so* $(1)/usr/lib/
	$(INSTALL_DIR) $(1)/usr/lib/pkgconfig
	$(INSTALL_DATA) $(PKG_INSTALL_DIR)/usr/lib/pkgconfig/sqlite3.pc $(1)/usr/lib/pkgconfig/
endef

define Package/libsqlite3/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libsqlite3.so* $(1)/usr/lib/
endef

$(eval $(call BuildPackage,libsqlite3))

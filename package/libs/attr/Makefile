#
# Copyright (C) 2014 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=attr
PKG_REV:=c252ef434219891f616d891b46aad6b06efdd185
PKG_VERSION:=20150220
PKG_RELEASE:=1

PKG_SOURCE_URL:=git://git.sv.gnu.org/attr.git
PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=$(PKG_REV)
PKG_MIRROR_HASH:=0d3ffbb22b34410011510d6ac014dfb0d2e72c48073497cda49b459a35a72a1d

PKG_LICENSE:=LGPL-2.1 GPL-2.0

PKG_INSTALL:=1
PKG_FIXUP:=autoreconf

include $(INCLUDE_DIR)/package.mk

define Package/attr/Default
  TITLE:=Extended attributes (xattr) manipulation
  URL:=http://savannah.nongnu.org/projects/attr
endef

define Package/attr/Default/description
  Extended attributes support
endef

define Package/attr
$(call Package/attr/Default)
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE+=utils
  DEPENDS:=+libattr
endef

define Package/libattr
$(call Package/attr/Default)
  SECTION:=libs
  CATEGORY:=Libraries
  TITLE+=library
endef

define Package/libattr/description
$(call Package/attr/Default/description)
 This package provides libattr
endef

define Package/attr/description
$(call Package/attr/Default/description)
 This package provides xattr manipulation utilities
 - attr
 - getfattr
 - setfattr
endef

CONFIGURE_ARGS += --enable-static --disable-shared
TARGET_CFLAGS += $(FPIC)

define Package/attr/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/* $(1)/usr/bin/
endef

define Package/libattr/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(INSTALL_DIR) $(1)/etc
	$(CP) $(PKG_INSTALL_DIR)/etc $(1)/
	#$(CP) $(PKG_INSTALL_DIR)/usr/lib/*.so* $(1)/usr/lib/
endef

define Package/attr/conffiles
/etc/xattr.conf
endef

define Build/InstallDev
	mkdir -p $(1)/usr/include
	mkdir -p $(1)/usr/lib/pkgconfig
	$(CP) -r $(PKG_INSTALL_DIR)/usr/{include,lib} $(1)/usr/
endef

$(eval $(call BuildPackage,attr))
$(eval $(call BuildPackage,libattr))

#
# Copyright (C) 2011-2012 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=libmnl
PKG_VERSION:=1.0.4
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.bz2
PKG_SOURCE_URL:= \
	http://www.netfilter.org/projects/libmnl/files \
	ftp://ftp.netfilter.org/pub/libmnl
PKG_HASH:=171f89699f286a5854b72b91d06e8f8e3683064c5901fb09d954a9ab6f551f81

PKG_LICENSE:=LGPL-2.1+

PKG_FIXUP:=autoreconf
PKG_INSTALL:=1

include $(INCLUDE_DIR)/package.mk

define Package/libmnl
  SECTION:=libs
  CATEGORY:=Libraries
  TITLE:=Minimalistic user-space library for Netlink
  URL:=http://www.netfilter.org/projects/libmnl/
endef

CONFIGURE_ARGS+= \
	--enable-shared \
	--enable-static \

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include
	$(CP) $(PKG_INSTALL_DIR)/usr/include/libmnl $(1)/usr/include/
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libmnl.{a,so*} $(1)/usr/lib/
	$(INSTALL_DIR) $(1)/usr/lib/pkgconfig
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/pkgconfig/libmnl.pc $(1)/usr/lib/pkgconfig/
endef

define Package/libmnl/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libmnl.so.* $(1)/usr/lib/
endef

$(eval $(call BuildPackage,libmnl))

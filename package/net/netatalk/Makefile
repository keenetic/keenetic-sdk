#
# Copyright (C) 2009-2012 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=netatalk
PKG_VERSION:=3.1.13-1
PKG_LICENSE:=GPL-2.0

PKG_SOURCE_URL:=$(NDM_STORAGE)/$(PKG_NAME)
PKG_SOURCE_VERSION:=$(PKG_VERSION)
PKG_SOURCE_PROTO:=git

PKG_INSTALL:=1
PKG_FIXUP:=autoreconf

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/ndm-build.mk

define Package/netatalk
  SECTION:=net
  CATEGORY:=Network
  DEPENDS:=+libattr +libdb47 +libgcrypt +libevent +libndm
  TITLE:=netatalk
  URL:=http://netatalk.sourceforge.net
endef

define Package/netatalk/decription
  Netatalk is a freely-available Open Source AFP fileserver.
  It also provides a kernel level implementation of the AppleTalk
  Protocol Suite.
endef

EXTRA_CFLAGS   := $(FPIC) -std=gnu99 -pthread

EXTRA_LDFLAGS  := $(FPIC) -lrt -lpthread

CONFIGURE_ARGS += \
	--disable-static \
	--disable-debug \
	--disable-afs \
	--enable-hfs \
	--disable-debugging \
	--disable-shell-check \
	--disable-timelord \
	--disable-a2boot \
	--disable-zeroconf \
	--disable-cups \
	--disable-tcp-wrappers \
	--with-cnid-default-backend=dbd \
	--with-bdb="$(STAGING_DIR)/usr/" \
	--with-libgcrypt-dir="$(STAGING_DIR)/usr" \
	--with-ssl-dir=no \
	--with-uams-path="/usr/lib/uams" \
	--with-pkgconfdir="/tmp" \
	--with-lockfile="/var/run/netatalk.pid" \
	--disable-srvloc \
	--without-shadow \
	--without-ldap \
	--without-kerberos \
	--without-dtrace \
	--with-acls=no \
	--with-mysql-config=no \
	--without-cnid-last-backend \
	--without-cnid-tdb-backend \
	--enable-libndm

define Package/netatalk/install
	$(INSTALL_DIR) $(1)/usr/lib
		$(CP) $(PKG_INSTALL_DIR)/usr/lib/lib*.so.* $(1)/usr/lib/

	$(INSTALL_DIR) $(1)/usr/lib/uams
		$(CP) $(PKG_INSTALL_DIR)/usr/lib/uams/uams_dhx2_passwd.so $(1)/usr/lib/uams/
		$(CP) $(PKG_INSTALL_DIR)/usr/lib/uams/uams_dhx2.so $(1)/usr/lib/uams/
		$(CP) $(PKG_INSTALL_DIR)/usr/lib/uams/uams_guest.so $(1)/usr/lib/uams/

	$(INSTALL_DIR) $(1)/usr/sbin
		$(CP) $(PKG_INSTALL_DIR)/usr/sbin/* $(1)/usr/sbin/

endef

$(eval $(call BuildPackage,netatalk))

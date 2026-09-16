#
# Copyright (C) 2007-2016 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=avahi
PKG_VERSION:=0.8
PKG_RELEASE:=1
PKG_LICENSE:=LGPL-2.1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://github.com/lathiat/avahi/releases/download/v$(PKG_VERSION)/
PKG_HASH:=060309d7a333d38d951bc27598c677af1796934dbd98e1024e7ad8de798fedda

PKG_INSTALL:=1
PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk

define Package/avahi/Default
  SECTION:=net
  CATEGORY:=Network
  TITLE:=An mDNS/DNS-SD implementation
  URL:=http://www.avahi.org/
endef

define Package/avahi/Default/description
 Avahi is an mDNS/DNS-SD (aka RendezVous/Bonjour/ZeroConf)
 implementation (library). It facilitates
 service discovery on a local network -- this means that
 you can plug your laptop or computer into a network and
 instantly be able to view other people who you can chat with,
 find printers to print to or find files being shared.
 This kind of technology is already found in MacOS X
 (branded 'Rendezvous', 'Bonjour' and sometimes 'ZeroConf')
 and is very convenient.
endef

define Package/libavahi
  $(call Package/avahi/Default)
  SECTION:=libs
  CATEGORY:=Libraries
  DEPENDS:=+libpthread
  TITLE+= (No D-Bus)
endef

define Package/libavahi/description
$(call Package/avahi/Default/description)
 .
 The libavahi package contains the mDNS/DNS-SD shared libraries,
 used by other programs. Specifically, it provides
 libavahi-core and libavahi-common libraries.
endef

define Package/avahi-daemon
  $(call Package/avahi/Default)
  DEPENDS:=+libavahi +libexpat +librt +libdaemon
  TITLE+= (daemon)
  USERID:=avahi=105:avahi=105
endef

define Package/avahi-daemon/description
$(call Package/avahi/Default/description)
 .
 This package contains an mDNS/DNS-SD daemon.
endef

TARGET_CFLAGS += -DGETTEXT_PACKAGE

CONFIGURE_ARGS+= \
	--disable-shared \
	--enable-static \
	--disable-glib \
	--disable-gobject \
	--disable-introspection \
	--disable-qt3 \
	--disable-qt4 \
	--disable-qt5 \
	--disable-gtk \
	--disable-gtk3 \
	--disable-dbm \
	--disable-gdbm \
	--enable-libdaemon \
	--disable-libevent \
	--disable-python \
	--disable-python-dbus \
	--disable-mono \
	--disable-monodoc \
	--disable-doxygen-doc \
	--disable-doxygen-dot \
	--disable-doxygen-man \
	--disable-doxygen-rtf \
	--disable-doxygen-xml \
	--disable-doxygen-chm \
	--disable-doxygen-chi \
	--disable-doxygen-html \
	--disable-doxygen-ps \
	--disable-doxygen-pdf \
	--disable-manpages \
	--disable-xmltoman \
	--disable-tests \
	--disable-autoipd \
	--with-xml=expat \
	--with-distro=none \
	--with-avahi-user=nobody \
	--with-avahi-group=nobody \
	--with-avahi-priv-access-group=nobody \
	--disable-dbus \
	--sysconfdir="/var/"

ifneq ($(CONFIG_SSP_SUPPORT),y)
CONFIGURE_ARGS+= \
	--disable-stack-protector
endif

CONFIGURE_VARS+= \
	CFLAGS="$$$$CFLAGS -DNDEBUG -DDISABLE_SYSTEMD" \
	ac_cv_header_sys_capability_h=no \

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include
	$(CP) $(PKG_INSTALL_DIR)/usr/include/* $(1)/usr/include/
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libavahi-* $(1)/usr/lib/
	$(INSTALL_DIR) $(1)/usr/lib/pkgconfig
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/pkgconfig/* $(1)/usr/lib/pkgconfig/
endef

define Package/libavahi/install
	#$(INSTALL_DIR) $(1)/usr/lib
	#$(CP) $(PKG_INSTALL_DIR)/usr/lib/libavahi-{common,core}.so.* $(1)/usr/lib/
endef

define Package/avahi-daemon/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/sbin/avahi-daemon $(1)/usr/sbin/
endef

$(eval $(call BuildPackage,libavahi))
$(eval $(call BuildPackage,avahi-daemon))

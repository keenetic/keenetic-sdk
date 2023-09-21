#
# Copyright (C) 2006-2010 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=libevent
PKG_VERSION:=2.1.12
PKG_RELEASE:=1
PKG_LICENSE:=BSD

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)-stable
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-stable.tar.gz
PKG_SOURCE_URL:=https://github.com/libevent/libevent/releases/download/release-$(PKG_VERSION)-stable/
PKG_HASH:=92e6de1be9ec176428fd2367677e61ceffc2ee1cb119035037a27d346b0403bb

PKG_LICENSE_FILES:=LICENSE

PKG_FIXUP:=autoreconf
PKG_INSTALL:=1

ifneq ($(CONFIG_USE_MKLIBS),)
  TARGET_LTO_FLAGS :=
endif

include $(INCLUDE_DIR)/package.mk

define Package/libevent
  SECTION:=libs
  CATEGORY:=Libraries
  DEPENDS:=+libpthread +libopenssl
  DEFAULT:=n
  TITLE:=Event notification library
  URL:=http://www.monkey.org/~provos/libevent/
endef

define Package/libevent/description
	The libevent API provides a mechanism to execute a callback function
	when a specific event occurs on a file descriptor or after a timeout
	has been reached. Furthermore, libevent also support callbacks due
	to signals or regular timeouts.

	libevent is meant to replace the event loop found in event driven
	network servers. An application just needs to call event_dispatch()
	and then add or remove events dynamically without having to change
	the event loop.
endef

EXTRA_CFLAGS   := -pthread -fPIC
EXTRA_LDFLAGS  := -pthread

CONFIGURE_ARGS += \
	--enable-shared \
	--enable-static \
	--disable-debug-mode \
	--disable-dependency-tracking \
	--disable-samples \
	--disable-libevent-regress \
	--disable-gcc-warnings

define Build/Compile
	+$(MAKE) $(PKG_JOBS) -C $(PKG_BUILD_DIR) \
	DESTDIR="$(PKG_INSTALL_DIR)" \
	all
	$(MAKE) -C $(PKG_BUILD_DIR) \
	DESTDIR="$(PKG_INSTALL_DIR)" \
	install
endef

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include
	$(CP) $(PKG_INSTALL_DIR)/usr/include/* $(1)/usr/include/
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libevent.{la,so} $(1)/usr/lib/
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libevent-2.*.so* $(1)/usr/lib/
	$(INSTALL_DIR) $(1)/usr/lib/pkgconfig
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/pkgconfig/libevent*.pc $(1)/usr/lib/pkgconfig
endef

define Package/libevent/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libevent-2.*.so.* $(1)/usr/lib/
endef

define Package/libevent/install_lib
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libevent.a $(1)/usr/lib/libevent-2.1_pic.a
endef

$(eval $(call BuildPackage,libevent))

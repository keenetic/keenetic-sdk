# 
# Copyright (C) 2006-2012 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk

PKG_NAME:=xz
PKG_VERSION:=5.2.7

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.bz2
PKG_SOURCE_URL:=http://tukaani.org/xz
PKG_HASH:=b65f1d0c2708e57716f4dd2216989a73847ac6fdb4168ffceb155767e22b834b

include $(INCLUDE_DIR)/host-build.mk

HOST_CONFIGURE_ARGS += \
	--enable-static=yes \
	--enable-shared=no \
	--disable-doc \
	--disable-nls \
	--with-pic

HOST_LDFLAGS += $(HOST_STATIC_LINKING)

define Host/Install
	+$(MAKE) $(HOST_JOBS) -C $(HOST_BUILD_DIR) install xzlinks="unxz xzcat" \
		AM_LDFLAGS="$(if $(HOST_STATIC_LINKING),-all-static)"
endef

$(eval $(call HostBuild))

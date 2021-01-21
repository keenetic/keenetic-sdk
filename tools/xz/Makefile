# 
# Copyright (C) 2006-2012 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk

PKG_NAME:=xz
PKG_VERSION:=5.0.4

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.bz2
PKG_SOURCE_URL:=http://tukaani.org/xz
PKG_HASH:=5cd9b060d3a1ad396b3be52c9b9311046a1c369e6062aea752658c435629ce92

include $(INCLUDE_DIR)/host-build.mk

HOST_CONFIGURE_ARGS += --disable-shared
HOST_LDFLAGS += $(HOST_STATIC_LINKING)

define Host/Install
	+$(MAKE) $(HOST_JOBS) -C $(HOST_BUILD_DIR) install xzlinks="unxz xzcat" \
		AM_LDFLAGS="$(if $(HOST_STATIC_LINKING),-all-static)"
endef

$(eval $(call HostBuild))

#
# Copyright (C) 2008-2012 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk

PKG_NAME:=ragel
PKG_VERSION:=6.9

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=http://www.colm.net/files/$(PKG_NAME)
PKG_HASH:=6e07be0fab5ca1d9c2d9e177718a018fc666141f594a5d6e7025658620cf660a
PKG_CAT:=zcat

include $(INCLUDE_DIR)/host-build.mk

HOST_CPPFLAGS += -std=gnu++98
HOST_LDFLAGS += $(HOST_STATIC_LINKING)

define Host/Clean
	-$(MAKE) -C $(HOST_BUILD_DIR) uninstall
	$(call Host/Clean/Default)
endef

$(eval $(call HostBuild))

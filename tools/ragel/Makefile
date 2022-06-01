#
# Copyright (C) 2008-2012 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk

PKG_NAME:=ragel
PKG_VERSION:=6.10

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=http://www.colm.net/files/$(PKG_NAME)
PKG_HASH:=5f156edb65d20b856d638dd9ee2dfb43285914d9aa2b6ec779dac0270cd56c3f
PKG_CAT:=zcat

include $(INCLUDE_DIR)/host-build.mk

HOST_CPPFLAGS += -std=gnu++98
HOST_LDFLAGS += $(HOST_STATIC_LINKING)

define Host/Clean
	-$(MAKE) -C $(HOST_BUILD_DIR) uninstall
	$(call Host/Clean/Default)
endef

$(eval $(call HostBuild))

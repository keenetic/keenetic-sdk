#
# Copyright (C) 2021 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=t1ha
PKG_VERSION:=v2.0.3-1
PKG_LICENSE:=ZLIB

PKG_SOURCE_URL:=$(NDM_STORAGE)/$(PKG_NAME)
PKG_SOURCE_VERSION:=$(PKG_VERSION)
PKG_SOURCE_PROTO:=git

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  NAME:=$(PKG_NAME)
  SECTION:=debug
  CATEGORY:=Debug suite
  TITLE:=T1HA hash benchmark
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/test $(1)/usr/sbin/t1ha-test
endef

$(eval $(call BuildPackage,$(PKG_NAME)))

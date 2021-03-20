#
# Copyright (C) 2021 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=wmond
PKG_VERSION:=1.0.29-8
PKG_LICENSE:=GPL-2.0

PKG_SOURCE_URL:=$(NDM_STORAGE)/$(PKG_NAME)
PKG_SOURCE_VERSION:=$(PKG_VERSION)
PKG_SOURCE_PROTO:=git

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  NAME:=$(PKG_NAME)
  SECTION:=net
  CATEGORY:=Network
  LICENSE=GPL-2
  DEPENDS:=
  TITLE:=Wireless event monitor daemon
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/wmond $(1)/usr/sbin/
endef

$(eval $(call BuildPackage,$(PKG_NAME)))

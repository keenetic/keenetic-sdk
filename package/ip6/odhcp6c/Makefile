#
# Copyright (C) 2012-2015 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=odhcp6c
PKG_VERSION:=1.0-0

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=$(NDM_STORAGE)/$(PKG_NAME)

PKG_SOURCE_VERSION:=$(PKG_VERSION)
PKG_MAINTAINER:=Hans Dedecker <dedeckeh@gmail.com>
PKG_LICENSE:=GPL-2.0

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/odhcp6c
  SECTION:=net
  CATEGORY:=IPv6
  TITLE:=Embedded DHCPv6-client
  DEPENDS:=@IPV6
endef

define Package/odhcp6c/install
	$(INSTALL_DIR) $(1)/usr/sbin/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/odhcp6c $(1)/usr/sbin/
endef

$(eval $(call BuildPackage,odhcp6c))

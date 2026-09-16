#
# Copyright (C) 2006-2013 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=ethtool
PKG_VERSION:=5.14
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.xz
PKG_SOURCE_URL:=@KERNEL/software/network/ethtool
PKG_HASH:=bb13db91915cacd7a492b65b65df07a67e4b974ddbeaf76205b1945a23d27686

PKG_INSTALL:=1
PKG_LICENSE:=GPL-2.0
PKG_FIXUP:=autoreconf

include $(INCLUDE_DIR)/package.mk

define Package/ethtool
  SECTION:=net
  CATEGORY:=Debug suite
  TITLE:=Display or change ethernet card settings
  URL:=http://www.kernel.org/pub/software/network/ethtool/
endef

define Package/ethtool/description
 ethtool is a small utility for examining and tuning your ethernet-based
 network interface
endef

CONFIGURE_ARGS += --disable-netlink --disable-pretty-dump

define Package/ethtool/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/ethtool $(1)/usr/sbin
endef

$(eval $(call BuildPackage,ethtool))

#
# Copyright (C) 2007-2011 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=tcpdump
PKG_VERSION:=4.99.5
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://www.tcpdump.org/release/
PKG_HASH:=8c75856e00addeeadf70dad67c9ff3dd368536b2b8563abf6854d7c764cd3adb

PKG_MAINTAINER:=Felix Fietkau <nbd@nbd.name>
PKG_LICENSE:=BSD
PKG_CPE_ID:=cpe:/a:tcpdump:tcpdump

PKG_INSTALL:=1

include $(INCLUDE_DIR)/package.mk

define Package/tcpdump
  SECTION:=debug
  CATEGORY:=Debug suite
  DEPENDS:=+libpcap
  TITLE:=Network monitoring and data acquisition tool
  URL:=http://www.tcpdump.org/
endef

CONFIGURE_ARGS += \
	--without-cap-ng \
	--without-crypto \
	--enable-ipv6

define Package/tcpdump/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/tcpdump $(1)/usr/bin/
endef

$(eval $(call BuildPackage,tcpdump))

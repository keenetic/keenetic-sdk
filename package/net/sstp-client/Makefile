#
# Copyright (C) 2006-2016 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=sstp-client
PKG_VERSION:=1.0.12-10
PKG_RELEASE:=1

PKG_SOURCE_URL:=$(NDM_STORAGE)/$(PKG_NAME)
PKG_SOURCE_VERSION:=$(PKG_VERSION)
PKG_SOURCE_PROTO:=git

PKG_LICENSE:=GPL-2.0+

PKG_FIXUP:=autoreconf

include $(INCLUDE_DIR)/package.mk

TARGET_CPPFLAGS += -I$(PKG_BUILD_DIR)/include

define Package/sstp-client
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=VPN
  DEPENDS=+libevent +libopenssl +ppp
  TITLE:=SSTP client for Linux
  URL:=http://sstp-client.sourceforge.net/
endef

CONFIGURE_ARGS += \
	--with-runtime-dir=/var/run \
	--with-pppd-plugin-dir=/usr/lib/pppd

define Build/Prepare
	$(call Build/Prepare/Default)
	$(CP) ./files/* $(PKG_BUILD_DIR)
endef

define Package/sstp-client/install
	$(INSTALL_DIR) $(1)/usr/{bin,lib}
	$(INSTALL_DIR) $(1)/usr/lib/pppd
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/.libs/sstpc $(1)/usr/bin/
	$(CP) $(PKG_BUILD_DIR)/src/libsstp-api/.libs/*.so* $(1)/usr/lib/
	$(CP) $(PKG_BUILD_DIR)/src/pppd-plugin/.libs/*.so* $(1)/usr/lib/pppd
endef

$(eval $(call BuildPackage,sstp-client))

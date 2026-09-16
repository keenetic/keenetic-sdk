#
# Copyright (C) 2021 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=br2684ctl
PKG_VERSION:=2.5.1-1
PKG_RELEASE:=1
PKG_LICENSE:=GPL-2.0

PKG_SOURCE_URL:=$(NDM_STORAGE)/$(PKG_NAME)
PKG_SOURCE_VERSION:=$(PKG_VERSION)
PKG_SOURCE_PROTO:=git

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  SECTION:=debug
  CATEGORY:=Debug suite
  TITLE:=RFC 2684 ATM/Ethernet bridging configure utility
  URL:=http://ftp.debian.org/debian/pool/main/l/linux-atm/linux-atm_2.5.1.orig.tar.gz
endef

MAKE_FLAGS += CFLAGS="$(TARGET_CPPFLAGS) $(TARGET_CFLAGS) $(TARGET_LDFLAGS)"

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/$(PKG_NAME) $(1)/usr/sbin/
endef

$(eval $(call BuildPackage,$(PKG_NAME)))

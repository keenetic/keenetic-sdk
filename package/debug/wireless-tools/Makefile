#
# Copyright (C) 2006 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
# $Id: Makefile 10188 2008-01-14 08:34:07Z agb $

include $(TOPDIR)/rules.mk

PKG_NAME:=wireless-tools
PKG_VERSION:=29
PKG_MINOR:=
PKG_RELEASE:=3

PKG_SOURCE:=wireless_tools.$(PKG_VERSION)$(PKG_MINOR).tar.gz
PKG_SOURCE_URL:=http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux
PKG_HASH:=6fb80935fe208538131ce2c4178221bab1078a1656306bce8909c19887e2e5a1
TAR_OPTIONS += || true

PKG_BUILD_DIR:=$(BUILD_DIR)/wireless_tools.$(PKG_VERSION)

PKG_LICENSE:=GPL-2.0

include $(INCLUDE_DIR)/package.mk

define Package/wireless-tools
  SECTION:=debug
  CATEGORY:=Debug suite
  TITLE:=Tools for manipulating Linux Wireless Extensions
  URL:=http://hplabs.hp.com/personal/Jean_Tourrilhes/Linux/Tools.html
endef

define Package/wireless-tools/description
 This package contains a collection of tools for configuring wireless
 adapters implementing the "Linux Wireless Extensions".
endef

EXTRA_CFLAGS  := $(FPIC)
EXTRA_LDFLAGS := $(FPIC)

define Build/Compile
	rm -rf $(PKG_INSTALL_DIR)
	mkdir -p $(PKG_INSTALL_DIR)
	+$(MAKE_VARS) \
		$(MAKE) -C $(PKG_BUILD_DIR) \
		$(MAKE_FLAGS) \
		CFLAGS="$(TARGET_CFLAGS) -I." \
		libiw.so.$(PKG_VERSION) iwmulticall
	$(MAKE) -C $(PKG_BUILD_DIR) \
		PREFIX="$(PKG_INSTALL_DIR)" \
		INSTALL_DIR="$(PKG_INSTALL_DIR)/usr/sbin" \
		INSTALL_LIB="$(PKG_INSTALL_DIR)/usr/lib" \
		install-iwmulticall
endef

define Build/InstallDev
	mkdir -p $(1)/usr/include
	$(CP) $(PKG_BUILD_DIR)/{iwlib,wireless}.h $(1)/usr/include/
	mkdir -p $(1)/usr/lib
	$(CP) $(PKG_BUILD_DIR)/libiw.so* $(1)/usr/lib/
	ln -sf libiw.so.$(PKG_VERSION) $(1)/usr/lib/libiw.so
endef

define Package/wireless-tools/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/sbin/iwconfig $(1)/usr/sbin/
	ln -sf iwconfig $(1)/usr/sbin/iwgetid
	ln -sf iwconfig $(1)/usr/sbin/iwlist
	ln -sf iwconfig $(1)/usr/sbin/iwpriv
	ln -sf iwconfig $(1)/usr/sbin/iwspy
endef

$(eval $(call BuildPackage,wireless-tools))

#
# Copyright (C) 2010-2015 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=openvpn
PKG_VERSION:=2.4.6-12
PKG_LICENSE:=GPL-2.0

PKG_SOURCE_URL:=$(NDM_STORAGE)/openvpn
PKG_SOURCE_VERSION:=$(PKG_VERSION)
PKG_SOURCE_PROTO:=git

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)

PKG_LICENSE_FILES:=COPYING

PKG_INSTALL:=1
PKG_FIXUP:=autoreconf

include $(INCLUDE_DIR)/package.mk

define Package/openvpn
  TITLE:=Open source VPN solution using OpenSSL
  SECTION:=net
  CATEGORY:=Network
  URL:=http://openvpn.net
  SUBMENU:=VPN
  DEPENDS:=+kmod-tun +liblzo +libopenssl +libndm
endef

EXTRA_CFLAGS   := -ffunction-sections \
                  -fdata-sections \
                  -Werror

EXTRA_LDFLAGS  := -Wl,--gc-sections

CONFIGURE_ARGS += \
		--enable-small \
		--disable-selinux \
		--disable-systemd \
		--disable-plugins \
		--disable-debug \
		--disable-pkcs11 \
		--enable-lzo \
		--enable-lz4 \
		--enable-server \
		--disable-management \
		--enable-fragment \
		--disable-multihome \
		--disable-iproute2 \
		--enable-def-auth \
		--enable-pf \
		--enable-ndm-integration \
		--with-crypto-library=openssl \

define Package/openvpn/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/sbin/openvpn $(1)/usr/sbin/
endef

$(eval $(call BuildPackage,openvpn))

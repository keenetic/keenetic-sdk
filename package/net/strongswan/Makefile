#
# Copyright (C) 2021 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=strongswan
PKG_VERSION:=5.8.0-5-5
PKG_LICENSE:=GPL-2.0+

PKG_SOURCE_URL:=$(NDM_STORAGE)/$(PKG_NAME)
PKG_SOURCE_VERSION:=$(PKG_VERSION)
PKG_SOURCE_PROTO:=git

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)

PKG_FIXUP:=autoreconf

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/kernel.mk

define Package/$(PKG_NAME)
  SECTION:=net
  CATEGORY:=Network
  DEPENDS:=\
	+libndm \
	+libatomic \
	+libopenssl \
	+kmod-ipt-ipsec \
	+kmod-ipt-ipopt \
	+kmod-ipsec4 \
	+kmod-crypto-aes \
	+kmod-crypto-des \
	+kmod-crypto-md5 \
	+kmod-crypto-sha1 \
	+kmod-crypto-sha256 \
	+kmod-arouting4
  TITLE:=Strongswan IKEv1/IKEv2 ISAKMP and IPSec suite
  URL:=https://www.strongswan.org/
endef

IPSEC_WORK_PATH:=/tmp/ipsec

CONFIGURE_ARGS += \
	--disable-constraints \
	--disable-dnskey \
	--disable-fips-prf \
	--disable-gmp \
	--disable-pgp \
	--disable-pkcs1 \
	--disable-pkcs7 \
	--disable-pkcs8 \
	--disable-pkcs12 \
	--disable-pki \
	--disable-sshkey \
	--disable-rc2 \
	--disable-revocation \
	--disable-scepclient \
	--disable-sshkey \
	--disable-aes \
	--disable-des \
	--disable-md5 \
	--disable-sha1 \
	--disable-sha2 \
	--disable-curve25519 \
	--disable-static \
	--disable-fast \
	--disable-scepclient \
	--disable-tpm \
	--disable-tss-trousers \
	--disable-tss-tss2 \
	--disable-pem \
	--enable-shared \
	--enable-monolithic \
	--enable-resolve \
	--enable-counters \
	--enable-vici \
	--enable-swanctl \
	--enable-xauth-generic \
	--enable-xauth-eap \
	--enable-eap-md5 \
	--enable-eap-mschapv2 \
	--enable-eap-dynamic \
	--enable-eap-identity \
	--enable-eap-radius \
	--enable-eap-peap \
	--enable-pubkey \
	--enable-openssl \
	--enable-xcbc \
	--enable-cmac \
	--enable-ctr \
	--enable-error-notify \
	--enable-systime-fix \
	--enable-unity \
	--enable-save-keys \
	--with-systemdsystemunitdir=no \
	--with-capabilities=native \
	--with-user=nobody \
	--with-group=nobody \
	--with-strongswan-conf=/etc/strongswan.conf \
	--with-resolv-conf=/tmp/resolv.conf \
	--with-piddir=$(IPSEC_WORK_PATH) \
	--sysconfdir=$(IPSEC_WORK_PATH)

define Build/Prepare
	$(call Build/Prepare/Default)
	$(LN) $(PKG_BUILD_DIR) $(BUILD_DIR)/$(PKG_NAME)
endef

define Build/Compile
	$(call Build/Compile/Default,DESTDIR="$(PKG_INSTALL_DIR)" install)
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/etc
	$(INSTALL_DIR) $(1)/etc/strongswan.d/charon
	$(INSTALL_DIR) $(1)/usr/lib/ipsec
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/ipsec/charon $(1)/usr/lib/ipsec
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/ipsec/starter $(1)/usr/lib/ipsec
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/ipsec/stroke $(1)/usr/lib/ipsec
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/ipsec/lib*.so* $(1)/usr/lib/ipsec
	$(INSTALL_DATA) ./files/strongswan.conf $(1)/etc/strongswan.conf
	$(INSTALL_DATA) ./files/basic-plugins.conf $(1)/etc/strongswan.d/charon/basic-plugins.conf
endef

$(eval $(call BuildPackage,$(PKG_NAME)))

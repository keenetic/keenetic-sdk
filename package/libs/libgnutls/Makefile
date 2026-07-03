# SPDX-Identifier-License: GPL-2.0-only
#
# Copyright (C) 2005-2016 OpenWrt.org
#

include $(TOPDIR)/rules.mk

PKG_NAME:=gnutls
PKG_VERSION:=3.8.11
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.xz
PKG_SOURCE_URL:=https://www.gnupg.org/ftp/gcrypt/gnutls/v3.8
PKG_HASH:=91bd23c4a86ebc6152e81303d20cf6ceaeb97bc8f84266d0faec6e29f17baa20

PKG_MAINTAINER:=Nikos Mavrogiannopoulos <nmav@gnutls.org>
PKG_LICENSE:=LGPL-2.1

PKG_BUILD_DEPENDS:=gettext-full/host
PKG_BUILD_PARALLEL:=1
PKG_FIXUP:=autoreconf gettext-version
PKG_INSTALL:=1
PKG_LIBTOOL_PATHS:=. lib

include $(INCLUDE_DIR)/package.mk


define Package/gnutls/Default
  SUBMENU:=SSL
  SECTION:=libs
  CATEGORY:=Libraries
  TITLE:=GNU TLS
  URL:=http://www.gnutls.org/
endef

define Package/gnutls/Default/description
 GnuTLS is a secure communications library implementing the SSL, TLS
 and DTLS protocols and technologies around them. It provides a simple
 C language application programming interface (API) to access the secure
 communications protocols as well as APIs to parse and write X.509, PKCS12,
 OpenPGP and other required structures. It is aimed to be portable and
 efficient with focus on security and interoperability.
endef

define Package/libgnutls
$(call Package/gnutls/Default)
  TITLE+= (library)
  DEPENDS+= +libnettle +libatomic +libpthread
endef

define Package/libgnutls-dane
$(call Package/gnutls/Default)
  TITLE+= (libgnutls-dane library)
  DEPENDS:= +libgnutls
endef

define Package/libgnutls/description
$(call Package/gnutls/Default/description)
 This package contains the GnuTLS shared library, needed by other programs.
endef

# We disable the configuration file (system-priority-file) because
# the use of configuration increases the non-shared memory used by
# the library and we don't provide an openwrt-specific configuration
# anyway.
CONFIGURE_ARGS+= \
	--enable-shared \
	--enable-static \
	--disable-doc \
	--disable-gcc-warnings \
	--disable-guile \
	--disable-rpath \
	--disable-seccomp-tests \
	--disable-tests \
	--disable-valgrind-tests \
	--disable-ssl2-support \
	--disable-ssl3-support \
	--enable-local-libopts \
	--without-idn \
	--with-default-trust-store-dir=/etc/ssl/certs/ \
	--with-included-unistring \
	--with-included-libunistring \
	--with-librt-prefix="$(LIBRT_ROOT_DIR)/" \
	--with-pic \
	--with-system-priority-file="" \
	--without-brotli \
	--without-zlib \
	--without-zstd \
	--with-included-libtasn1 \
	--without-p11-kit \
	--with-nettle-mini \
	--disable-dtls-srtp-support \
	--disable-srp-authentication \
	--disable-anon-authentication \
	--enable-ocsp \
	--without-tpm \
	--disable-libdane \
	--disable-cxx \
	--disable-gost

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include $(1)/usr/lib/pkgconfig
	$(CP) \
		$(PKG_INSTALL_DIR)/usr/lib/*.so* \
		$(1)/usr/lib/
	$(CP) \
		$(PKG_INSTALL_DIR)/usr/include/gnutls \
		$(1)/usr/include/
	$(CP) \
		$(PKG_INSTALL_DIR)/usr/lib/pkgconfig/*.pc \
		$(1)/usr/lib/pkgconfig/
endef

define Package/libgnutls/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libgnutls.so.* $(1)/usr/lib/
endef

$(eval $(call BuildPackage,libgnutls))

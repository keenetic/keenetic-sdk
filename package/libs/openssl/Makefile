#
# Copyright (C) 2006-2012 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=openssl
PKG_VERSION:=3.0.8
PKG_RELEASE:=1
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=http://mirror.switch.ch/ftp/mirror/openssl/source/ \
	http://www.openssl.org/source/ \
	ftp://sunsite.uio.no/pub/security/openssl/source/ \
	http://artfiles.org/openssl.org/source/ \
	ftp://ftp.pca.dfn.de/pub/tools/net/openssl/source/ \
	ftp://guest.kuria.katowice.pl/pub/openssl/source/ \
	https://www.openssl.org/source/old/1.1.1/
PKG_HASH:=6c13d2bf38fdf31eac3ce2a347073673f5d63263398f1f69d0df4a41253e4b3e

PKG_DEBUG:=false
PKG_LICENSE:=Apache-2.0
PKG_LICENSE_FILES:=LICENSE.txt
PKG_CONFIG_DEPENDS:= \
	CONFIG_OPENSSL_ENGINE_CRYPTO \
	CONFIG_OPENSSL_ENGINE_DIGEST \
	CONFIG_OPENSSL_OPTIMIZE_SPEED

ifneq ($(CONFIG_USE_MKLIBS),)
  TARGET_LTO_FLAGS :=
endif

include $(INCLUDE_DIR)/package.mk

define Package/openssl/Default
  TITLE:=Open source SSL toolkit
  URL:=http://www.openssl.org/
endef

define Package/libopenssl/config
source "$(SOURCE)/Config.in"
endef

define Package/openssl/Default/description
The OpenSSL Project is a collaborative effort to develop a robust,
commercial-grade, full-featured, and Open Source toolkit implementing the Secure
Sockets Layer (SSL v2/v3) and Transport Layer Security (TLS v1) protocols as well
as a full-strength general purpose cryptography library.
endef

define Package/libopenssl
$(call Package/openssl/Default)
  SECTION:=libs
  CATEGORY:=Libraries
  DEPENDS:=+zlib +libpthread +libatomic \
    +OPENSSL_ENGINE_BUILTIN_DEVCRYPTO:kmod-cryptodev-linux
  TITLE+= (libraries (libcrypto.so, libssl.so))
  MENU:=1
endef

define Package/libopenssl/description
$(call Package/openssl/Default/description)
This package contains the OpenSSL shared libraries, needed by other programs.
endef

define Package/openssl-util
  $(call Package/openssl/Default)
  SECTION:=utils
  CATEGORY:=Utilities
  DEPENDS:=+libopenssl
  TITLE+= (utility)
endef

define Package/openssl-util/conffiles
/etc/ssl/openssl.cnf
endef

define Package/openssl-util/description
$(call Package/openssl/Default/description)
This package contains the OpenSSL command-line utility.
endef

OPENSSL_NO_CIPHERS:= no-idea no-mdc2 no-rc5 no-rmd160 \
	no-camellia no-idea no-seed no-whirlpool no-srp no-gost \
	no-aria no-blake2 no-siphash no-sm2 no-sm3 no-sm4 no-psk

OPENSSL_OPTIONS:= shared threads no-err zlib-dynamic no-sse2 no-tests \
	no-afalgeng no-cms no-comp no-ct no-ubsan no-ssl-trace no-sctp no-msan \
	no-unit-test no-nextprotoneg no-rfc3779 no-ts \
	no-filenames no-multiblock no-rdrand no-autoload-config no-capieng \
	no-acvp-tests no-afalgeng no-buildtest-c++ no-asan \
	no-crypto-mdebug no-external-tests \
	no-fips no-fips-securitychecks no-fuzz-afl no-fuzz-libfuzzer \
	no-ktls no-padlockeng no-ssl-trace no-static-engine no-unit-test \
	no-ssl3-method no-cmp no-ui-console

ifneq ($(CONFIG_OPENSSL_TLS13),y)
	OPENSSL_OPTIONS += no-tls1_3
endif

ifneq ($(CONFIG_OPENSSL_OCSP),y)
	OPENSSL_OPTIONS += no-ocsp
endif

ifneq ($(CONFIG_OPENSSL_OLD_PROTOS),y)
	OPENSSL_OPTIONS += no-ssl3 no-tls1_1
endif

ifneq ($(CONFIG_OPENSSL_OLD_ALGOS),y)
	OPENSSL_OPTIONS += no-dsa no-cast
endif

ifdef CONFIG_OPENSSL_ENGINE
  ifdef CONFIG_OPENSSL_ENGINE_BUILTIN
    OPENSSL_OPTIONS += no-dynamic-engine
    ifdef CONFIG_OPENSSL_ENGINE_BUILTIN_DEVCRYPTO
      OPENSSL_OPTIONS += no-devcryptoeng
    endif
  else
    ifdef CONFIG_PACKAGE_libopenssl-devcrypto
      OPENSSL_OPTIONS += enable-devcryptoeng
    endif
  endif
else
  OPENSSL_OPTIONS += no-engine no-dynamic-engine no-devcryptoeng
endif

ifndef CONFIG_OPENSSL_WITH_ASYNC
  OPENSSL_OPTIONS += no-async
endif

ifeq ($(CONFIG_mips),y)
  OPENSSL_TARGET:=linux-mips-ndm32eb
else ifeq ($(CONFIG_mipsel),y)
  OPENSSL_TARGET:=linux-mips-ndm32le
else ifeq ($(CONFIG_aarch64),y)
  OPENSSL_TARGET:=linux-aarch64
else
  OPENSSL_TARGET:=linux-generic32
  OPENSSL_OPTIONS+=no-perlasm
endif

ifeq ($(CONFIG_OPENSSL_OPTIMIZE_SPEED),y)
  TARGET_CFLAGS := $(filter-out -Os,$(TARGET_CFLAGS)) -O3
endif

define Build/Configure
	(cd $(PKG_BUILD_DIR); \
		$(TARGET_CONFIGURE_OPTS) \
		./Configure $(OPENSSL_TARGET) \
			--prefix=/usr \
			--openssldir=/etc/ssl \
			--release \
			$(TARGET_CFLAGS) \
			$(TARGET_LDFLAGS) -ldl \
			$(if $(CONFIG_OPENSSL_OPTIMIZE_SPEED),,-DOPENSSL_SMALL_FOOTPRINT) \
			$(OPENSSL_NO_CIPHERS) \
			$(OPENSSL_OPTIONS) \
	)
endef

TARGET_CFLAGS += $(FPIC) -ffunction-sections -fdata-sections
TARGET_LDFLAGS += -Wl,--gc-sections

define Build/Compile
	# XXX: OpenSSL "make depend" will look for installed headers before its own,
	# so remove installed stuff first
	-$(SUBMAKE) -j1 clean-staging
	+$(MAKE) $(PKG_JOBS) -C $(PKG_BUILD_DIR) \
		OPENWRT_OPTIMIZATION_FLAGS="$(TARGET_CFLAGS)" \
		$(OPENSSL_MAKEFLAGS) \
		build_sw
	+$(MAKE) -C $(PKG_BUILD_DIR) \
		DESTDIR="$(PKG_INSTALL_DIR)" \
		$(OPENSSL_MAKEFLAGS) \
		install_sw
	$(MAKE) -C $(PKG_BUILD_DIR) \
		DESTDIR="$(PKG_INSTALL_DIR)" \
		$(OPENSSL_MAKEFLAGS) \
		install_ssldirs
endef

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include
	$(CP) $(PKG_INSTALL_DIR)/usr/include/openssl $(1)/usr/include/
	$(INSTALL_DIR) $(1)/usr/lib/
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/lib{crypto,ssl}.{a,so*} $(1)/usr/lib/
	$(INSTALL_DIR) $(1)/usr/lib/pkgconfig
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/pkgconfig/{openssl,libcrypto,libssl}.pc $(1)/usr/lib/pkgconfig/
	[ -n "$(TARGET_LDFLAGS)" ] && $(SED) 's#$(TARGET_LDFLAGS)##g' $(1)/usr/lib/pkgconfig/{openssl,libcrypto,libssl}.pc || true
endef

define Package/libopenssl/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(INSTALL_DIR) $(1)/usr/lib/ossl-modules
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/lib/libcrypto.so.* $(1)/usr/lib/
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/lib/libssl.so.* $(1)/usr/lib/
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/lib/ossl-modules/* $(1)/usr/lib/ossl-modules
	$(LN) libcrypto.so.3 $(1)/usr/lib/libcrypto.so
	$(LN) libcrypto.so.3 $(1)/usr/lib/libcrypto.so.1
	$(LN) libcrypto.so.3 $(1)/usr/lib/libcrypto.so.1.1
endef

define Package/libopenssl/install_lib
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libcrypto.a $(1)/usr/lib/libcrypto_pic.a
endef

define Package/openssl-util/install
	$(INSTALL_DIR) $(1)/etc/ssl
	$(CP) $(PKG_INSTALL_DIR)/etc/ssl/openssl.cnf $(1)/etc/ssl/
	$(INSTALL_DIR) $(1)/etc/ssl/certs
	$(INSTALL_DIR) $(1)/etc/ssl/private
	chmod 0700 $(1)/etc/ssl/private
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/openssl $(1)/usr/bin/
endef

$(eval $(call BuildPackage,libopenssl))
$(eval $(call BuildPackage,openssl-util))

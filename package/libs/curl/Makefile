# 
# Copyright (C) 2007-2011 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=curl
PKG_VERSION:=8.0.1
PKG_RELEASE:=1
PKG_LICENSE:=MIT

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.xz
PKG_SOURCE_URL:=https://dl.uxnr.de/mirror/curl/ \
	https://curl.askapache.com/download/ \
	https://curl.se/download/
PKG_HASH:=0a381cd82f4d00a9a334438b8ca239afea5bfefcfa9a1025f2bf118e79e0b5f0

PKG_LICENSE:=MIT
PKG_LICENSE_FILES:=COPYING

PKG_FIXUP:=autoreconf

include $(INCLUDE_DIR)/package.mk

define Package/curl/Default
  SECTION:=debug
  CATEGORY:=Debug suite
  URL:=http://curl.haxx.se/
endef

define Package/curl
  $(call Package/curl/Default)
  DEPENDS:=+libcurl
  TITLE:=A client-side URL transfer utility
endef

define Package/libcurl
  $(call Package/curl/Default)
  SECTION:=libs
  CATEGORY:=Libraries
  DEPENDS:=+zlib +libopenssl \
    +LIBCURL_NGHTTP2:libnghttp2 \
    +LIBCURL_CA:ca-certificates \
    +LIBCURL_BACKTRACE:libfatalsig
  TITLE:=A client-side URL transfer library
endef

define Package/libcurl/config
source "$(SOURCE)/Config.in"
endef

CONFIGURE_ARGS += \
	--enable-shared \
	--disable-debug \
	--disable-curldebug \
	--enable-cookies \
	--enable-crypto-auth \
	--enable-nonblocking \
	--enable-symbol-hiding \
	--enable-file \
	--enable-ftp \
	--enable-http \
	--disable-static \
	--disable-ldap \
	--disable-ldaps \
	--disable-rtsp \
	--disable-proxy \
	--disable-dict \
	--disable-pop3 \
	--disable-imap \
	--disable-smtp \
	--disable-ares \
	--disable-debug \
	--disable-dict \
	--disable-gopher \
	--disable-ldap \
	--disable-manual \
	--disable-sspi \
	--disable-telnet \
	--enable-tftp \
	--disable-verbose \
	--disable-smb \
	$(if $(CONFIG_LIBCURL_NGHTTP2),--with-nghttp2="$(STAGING_DIR)/usr",--without-nghttp2) \
	--with-random="/dev/urandom" \
	--with-ssl="$(STAGING_DIR)/usr" \
	$(if $(CONFIG_LIBCURL_CA),--with-ca-path=/etc/ssl/certshashed \,--without-ca-path) \
	--without-ca-path \
	--without-gnutls \
	--without-krb4 \
	--without-libidn \
	--without-nss \
	--without-libssh2 \
	--without-axtls \
	--without-librtmp \
	--without-zstd \
	--with-zlib="$(STAGING_DIR)/usr" \
	$(call autoconf_bool,CONFIG_IPV6,ipv6) \

ifeq ($(CONFIG_LIBCURL_BACKTRACE),y)
TARGET_CFLAGS  := $(filter-out \
                     -fno-asynchronous-unwind-tables \
                     -fomit-frame-pointer \
                     -fno-caller-saves \
                   , $(TARGET_CFLAGS)) \
                  -fasynchronous-unwind-tables \
                  -fno-omit-frame-pointer \
                  -fcaller-saves \
                  $(FPIC)
RSTRIP         := :
STRIP          := :
endif

CONFIGURE_VARS += \
	LIBS="-lz" \
	CC="$(filter-out ccache,$(TARGET_CC))"

define Build/Compile
	+$(MAKE) $(PKG_JOBS) -C $(PKG_BUILD_DIR) \
		DESTDIR="$(PKG_INSTALL_DIR)" \
		CC="$(TARGET_CC)" \
		install
endef

define Build/InstallDev
	$(INSTALL_DIR) $(2)/bin $(1)/usr/bin $(1)/usr/include $(1)/usr/lib $(1)/usr/lib/pkgconfig
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/curl-config $(1)/usr/bin/
	$(CP) $(PKG_INSTALL_DIR)/usr/include/curl $(1)/usr/include/
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libcurl.so* $(1)/usr/lib/
	$(CP) $(PKG_BUILD_DIR)/libcurl.pc $(1)/usr/lib/pkgconfig/
	$(SED) 's,-L$$$${exec_prefix}/lib,,g' $(1)/usr/bin/curl-config
	[ -n "$(TARGET_LDFLAGS)" ] && $(SED) 's#$(TARGET_LDFLAGS)##g' $(1)/usr/lib/pkgconfig/libcurl.pc || true
	ln -sf $(STAGING_DIR)/usr/bin/curl-config $(2)/bin/
endef

define Package/curl/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/curl $(1)/usr/bin/
endef

define Package/libcurl/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libcurl.so.* $(1)/usr/lib/
endef

$(eval $(call BuildPackage,curl))
$(eval $(call BuildPackage,libcurl))

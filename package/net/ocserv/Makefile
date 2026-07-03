#
# Copyright (C) 2007-2011 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=ocserv
PKG_VERSION:=1.2.4-3
PKG_RELEASE:=1

PKG_SOURCE_URL:=$(NDM_STORAGE)/$(PKG_NAME)
PKG_SOURCE_VERSION:=$(PKG_VERSION)
PKG_SOURCE_PROTO:=git

PKG_LICENSE:=GPL-2.0-or-later
PKG_LICENSE_FILES:=COPYING

PKG_FIXUP:=autoreconf

include $(INCLUDE_DIR)/package.mk

define Package/ocserv
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=VPN
  TITLE:=OpenConnect VPN server
  URL:=http://www.infradead.org/ocserv/
  MAINTAINER:=Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>
  DEPENDS:=+libgnutls +libev +kmod-tun +libndm +libradcli
endef

define Package/ocserv/description
 OpenConnect server (ocserv) is an SSL VPN server. Its purpose is to be
 a secure, small, fast and configurable VPN server. It implements the
 OpenConnect SSL VPN protocol, and has also (currently experimental)
 compatibility with clients using the AnyConnect SSL VPN protocol. The
 OpenConnect VPN protocol uses the standard IETF security protocols such
 as TLS 1.2, and Datagram TLS to provide the secure VPN service.
endef

EXTRA_LDFLAGS+=-lm

CONFIGURE_VARS += \
	ac_cv_file__proc_self_exe=yes

CONFIGURE_ARGS+= \
	--with-pager="" \
	--without-libnl \
	--without-gssapi \
	--without-maxmind \
	--without-libreadline-prefix \
	--with-libcrypt-prefix="$(STAGING_DIR)/" \
	--with-libev-prefix="$(STAGING_DIR)/" \
	--without-lz4 \
	--with-local-talloc \
	--without-pam \
	--disable-seccomp \
	--without-protobuf \
	--without-http-parser \
	--without-liboath

define Package/ocserv/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/ocserv $(1)/usr/sbin/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/ocserv-worker $(1)/usr/sbin/
endef

$(eval $(call BuildPackage,ocserv))

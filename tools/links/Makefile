#
# Copyright (C) 2021 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=links
PKG_VERSION:=2.28

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=http://links.twibright.com/download
PKG_HASH:=b20bcac4817e338a91653fad1ba062cf4416d7107a146aade3cb7a9d46e0c370

include $(INCLUDE_DIR)/host-build.mk

GETOPT:=$(shell which getopt)

HOST_CONFIGURE_ARGS += \
	--with-utf8 \
	--without-getaddrinfo \
	--without-ipv6 \
	--without-libevent \
	--without-gpm \
	--without-graphics

define Host/Configure
	cd $(HOST_BUILD_DIR) && autoconf
	$(call Host/Configure/Default)
	[ -f $(HOST_BUILD_DIR)/Makefile ]
endef

define Host/Compile
	+$(MAKE) $(HOST_JOBS) -C $(HOST_BUILD_DIR) SHELL="$(BASH)" all
endef

define Host/Install
	$(MAKE) -C $(HOST_BUILD_DIR) SHELL="$(BASH)" install
endef

define Host/Clean
	rm -f $(STAGING_DIR_HOST)/bin/links
endef

$(eval $(call HostBuild))

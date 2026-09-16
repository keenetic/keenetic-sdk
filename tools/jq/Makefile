#
# Copyright (C) 2017 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk

PKG_NAME:=jq
PKG_VERSION:=1.8.1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://github.com/jqlang/jq/releases/download/$(PKG_NAME)-$(PKG_VERSION)
PKG_HASH:=2be64e7129cecb11d5906290eba10af694fb9e3e7f9fc208a311dc33ca837eb0

include $(INCLUDE_DIR)/host-build.mk

HOST_CONFIGURE_ARGS += \
	--disable-docs \
	--disable-valgrind \
	--enable-all-static \
	--without-oniguruma

define Host/Install
	$(INSTALL_BIN) $(HOST_BUILD_DIR)/jq $(STAGING_DIR_HOST)/bin/
endef

define Host/Clean
	rm -f $(STAGING_DIR_HOST)/bin/jq
	$(call Host/Clean/Default)
endef

$(eval $(call HostBuild))

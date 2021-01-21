#
# Copyright (C) 2021 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NPM_NAME:=gulp
PKG_NAME:=node-$(PKG_NPM_NAME)
PKG_VERSION:=3.9.1
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NPM_NAME)-$(PKG_VERSION).tgz
PKG_SOURCE_URL:=http://registry.npmjs.org/$(PKG_NPM_NAME)/-/
PKG_HASH:=61ca320c45410ffe09aa1b7b67ae48eb22c8b6d219ed9f91931f12d5e381fdb0

include $(INCLUDE_DIR)/host-build.mk

define Host/Prepare
	gzip -dc $(DL_DIR)/$(PKG_SOURCE) | $(HOST_TAR) -C $(HOST_BUILD_DIR) $(TAR_OPTIONS)
	$(Host/Patch)
endef

define Host/Compile
	$(STAGING_DIR_HOST)/bin/npm install -g $(HOST_BUILD_DIR)/package
endef

define Host/Install
endef

$(eval $(call HostBuild))

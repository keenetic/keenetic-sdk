#
# Copyright (C) 2021 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NPM_NAME:=bower
PKG_NAME:=node-$(PKG_NPM_NAME)
PKG_VERSION:=1.8.4
PKG_RELEASE:=6

PKG_SOURCE:=$(PKG_NPM_NAME)-$(PKG_VERSION).tgz
PKG_SOURCE_URL:=http://registry.npmjs.org/$(PKG_NPM_NAME)/-/
PKG_HASH:=e5071eca9d4b69aee04f8dc5cea0304b259b496e969c7e997e8b6fc3089857af

include $(INCLUDE_DIR)/host-build.mk

define Host/Prepare
	gzip -dc $(DL_DIR)/$(PKG_SOURCE) | $(HOST_TAR) -C $(HOST_BUILD_DIR) $(TAR_OPTIONS)
endef

define Host/Compile
	$(STAGING_DIR_HOST)/bin/npm install -g $(HOST_BUILD_DIR)/package
endef

define Host/Install
endef

$(eval $(call HostBuild))

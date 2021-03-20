# 
# Copyright (C) 2006 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk

PKG_NAME:=ipkg-utils
PKG_VERSION:=1.7

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=http://handhelds.org/packages/ipkg-utils/ \
	https://ftp.gwdg.de/pub/linux/handhelds/packages/ipkg-utils/
PKG_HASH:=813428c1aac04393ba64d0a23f9f820277357cbcdbdd391b9cf2bbf5257e8625

include $(INCLUDE_DIR)/host-build.mk

define Host/Install
	$(INSTALL_BIN) \
		$(HOST_BUILD_DIR)/ipkg-build \
		$(HOST_BUILD_DIR)/ipkg-buildpackage \
		$(HOST_BUILD_DIR)/ipkg-make-index \
		$(HOST_BUILD_DIR)/ipkg.py \
		$(STAGING_DIR_HOST)/bin/
endef

define Host/Clean
	rm -f $(STAGING_DIR)/etc/ipkg.conf
	rm -f $(STAGING_DIR_HOST)/bin/ipkg*
endef

$(eval $(call HostBuild))

# 
# Copyright (C) 2006 -2010 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk

PKG_NAME:=quilt
PKG_VERSION:=0.48

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=http://download.savannah.gnu.org/releases/$(PKG_NAME)
PKG_HASH:=73fd760d3b5cbf06417576591dc37d67380d189392db9000c21b7cbebee49ffc

include $(INCLUDE_DIR)/host-build.mk

GETOPT:=$(shell which getopt)

HOST_CONFIGURE_ARGS += \
	--with-patch=$(PATCH) \
	--with-find=$(FIND) \
	--with-getopt=$(GETOPT)

define Host/Configure
	cd $(HOST_BUILD_DIR) && autoconf
	$(call Host/Configure/Default)
	[ -f $(HOST_BUILD_DIR)/Makefile ]
endef

define Host/Compile
	+$(MAKE) $(HOST_JOBS) -C $(HOST_BUILD_DIR) SHELL="$(BASH)" all lib/backup-files
endef

define Host/Install
	$(MAKE) -C $(HOST_BUILD_DIR) SHELL="$(BASH)" install
endef

define Host/Clean
	rm -f $(STAGING_DIR_HOST)/bin/quilt
endef

$(eval $(call HostBuild))

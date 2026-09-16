#
# Copyright (C) 2021 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk

PKG_NAME:=discount
PKG_VERSION:=2.2.4

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.bz2
PKG_SOURCE_URL:=http://www.pell.portland.or.us/~orc/Code/discount
PKG_HASH:=74fd1e3cc2b4eacf7325d3fd89df38b589db60d5dd0f4f14a0115f7da5e230a5

include $(INCLUDE_DIR)/host-build.mk

HOST_CFLAGS         := -O2 -pipe
HOST_CONFIGURE_CMD  := ./configure.sh
HOST_CONFIGURE_ARGS := --DEBIAN-GLITCH

define Host/Install
	$(INSTALL_DIR) $(STAGING_DIR_HOST)/bin
	$(INSTALL_BIN) $(HOST_BUILD_DIR)/markdown $(STAGING_DIR_HOST)/bin
endef

define Host/Clean
	rm -f $(STAGING_DIR_HOST)/bin/markdown
	$(call Host/Clean/Default)
endef

$(eval $(call HostBuild))

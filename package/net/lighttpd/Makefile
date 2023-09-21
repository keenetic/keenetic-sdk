#
# Copyright (C) 2023 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=lighttpd
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define Package/lighttpd
  SUBMENU:=Web Servers/Proxies
  CATEGORY:=Network
  TITLE:=A flexible and lightweight web server
  DEPENDS:=+libc +SSP_SUPPORT:libssp +libpthread +libsqlite3 +libuuid +libxml2 +libpcre +libndm +libndmacl_stub
  DISABLE_RSTRIP:=y
endef

define Package/lighttpd/install
	if [ -d ./files-lighttpd ]; then \
		$(CP) ./files-lighttpd/* $(1); \
	fi
endef

$(eval $(call BuildPackage,lighttpd))

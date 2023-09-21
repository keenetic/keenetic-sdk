#
# Copyright (C) 2023 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=nginx
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define Package/nginx
  CATEGORY:=Network
  TITLE:=Nginx web server
  DEPENDS:=+libc +SSP_SUPPORT:libssp +NGINX_BACKTRACE:libfatalsig +libndmacl_stub +zlib +libopenssl +libndm
  DISABLE_RSTRIP:=y
endef

define Package/nginx/config
	source "package/net/nginx/nginx.in"
endef

define Package/nginx/install
	if [ -d ./files-nginx ]; then \
		$(CP) ./files-nginx/* $(1); \
	fi
endef

$(eval $(call BuildPackage,nginx))

define Package/nginx-stream-module
  CATEGORY:=Network
  TITLE:=Nginx stream module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +nginx
  DISABLE_RSTRIP:=y
endef

define Package/nginx-stream-module/install
	if [ -d ./files-nginx-stream-module ]; then \
		$(CP) ./files-nginx-stream-module/* $(1); \
	fi
endef

$(eval $(call BuildPackage,nginx-stream-module))

#
# Copyright (C) 2023 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=https-dns-proxy
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define Package/https-dns-proxy
  CATEGORY:=Network
  TITLE:=DNS over HTTPS proxy server
  DEPENDS:=+libc +SSP_SUPPORT:libssp +libcares +libcurl +libev +ca-certificates +libndm +HTTPS_DNS_PROXY_BACKTRACE:libfatalsig
  DISABLE_RSTRIP:=y
endef

define Package/https-dns-proxy/config
	source "package/net/https-dns-proxy/https-dns-proxy.in"
endef

define Package/https-dns-proxy/install
	if [ -d ./files-https-dns-proxy ]; then \
		$(CP) ./files-https-dns-proxy/* $(1); \
	fi
endef

$(eval $(call BuildPackage,https-dns-proxy))

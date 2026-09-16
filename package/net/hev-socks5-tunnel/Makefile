#
# Copyright (C) 2026 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=hev-socks5-tunnel
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define Package/hev-socks5-tunnel
  SUBMENU:=VPN
  CATEGORY:=Network
  TITLE:=HEV SOCKS5 tunnel
  DEPENDS:=+libc +SSP_SUPPORT:libssp +librt +libpthread
  DISABLE_RSTRIP:=y
endef

define Package/hev-socks5-tunnel/install
	if [ -d ./files-hev-socks5-tunnel ]; then \
		$(CP) ./files-hev-socks5-tunnel/* $(1); \
	fi
endef

$(eval $(call BuildPackage,hev-socks5-tunnel))

#
# Copyright (C) 2023 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=badvpn
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define Package/badvpn
  SUBMENU:=VPN
  CATEGORY:=Network
  TITLE:=BadVPN
  DEPENDS:=+libc +SSP_SUPPORT:libssp +librt +libpthread +libopenssl +libndm
  DISABLE_RSTRIP:=y
endef

define Package/badvpn/install
	if [ -d ./files-badvpn ]; then \
		$(CP) ./files-badvpn/* $(1); \
	fi
endef

$(eval $(call BuildPackage,badvpn))

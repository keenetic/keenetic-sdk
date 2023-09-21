#
# Copyright (C) 2023 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=miniupnpd
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define Package/miniupnpd
  CATEGORY:=Network
  TITLE:=Lightweight UPnP daemon
  DEPENDS:=+libc +SSP_SUPPORT:libssp +libndm
  DISABLE_RSTRIP:=y
endef

define Package/miniupnpd/install
	if [ -d ./files-miniupnpd ]; then \
		$(CP) ./files-miniupnpd/* $(1); \
	fi
endef

$(eval $(call BuildPackage,miniupnpd))

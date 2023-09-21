#
# Copyright (C) 2023 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=ping
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define Package/ping
  CATEGORY:=Network
  TITLE:=PING utility for NDM
  DEPENDS:=+libc +SSP_SUPPORT:libssp +librt
  DISABLE_RSTRIP:=y
endef

define Package/ping/install
	if [ -d ./files-ping ]; then \
		$(CP) ./files-ping/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ping))

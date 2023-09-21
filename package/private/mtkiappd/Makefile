#
# Copyright (C) 2023 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=mtkiappd
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define Package/mtkiappd
  CATEGORY:=Network
  TITLE:=MediaTek IAPP implementation
  DEPENDS:=+libc +SSP_SUPPORT:libssp +librt +libndm
  DISABLE_RSTRIP:=y
endef

define Package/mtkiappd/install
	if [ -d ./files-mtkiappd ]; then \
		$(CP) ./files-mtkiappd/* $(1); \
	fi
endef

$(eval $(call BuildPackage,mtkiappd))

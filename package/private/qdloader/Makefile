#
# Copyright (C) 2023 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=qdloader
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define Package/qdloader
  CATEGORY:=Base system
  TITLE:=Firmware update utility for Quectel modems
  DEPENDS:=+libc +SSP_SUPPORT:libssp @(TARGET_mt7621_KN_2311||TARGET_mt7621_KN_2910||TARGET_mt7628_KN_2211)
  DISABLE_RSTRIP:=y
endef

define Package/qdloader/install
	if [ -d ./files-qdloader ]; then \
		$(CP) ./files-qdloader/* $(1); \
	fi
endef

$(eval $(call BuildPackage,qdloader))

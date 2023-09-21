#
# Copyright (C) 2023 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=bndstrg
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define Package/bndstrg
  CATEGORY:=Network
  TITLE:=MediaTek Band Steering daemon
  DEPENDS:=+libc +SSP_SUPPORT:libssp +librt @!TARGET_mt7628_KN_1110 @!TARGET_mt7628_KN_1111 @!TARGET_mt7628_KN_1112 @!TARGET_mt7628_KN_1210 @!TARGET_mt7628_KN_1211 @!TARGET_mt7628_KN_1212 @!TARGET_mt7628_KN_1310 @!TARGET_mt7628_KN_1311 @!TARGET_mt7628_KN_1410 @!TARGET_mt7628_KN_2210 @!TARGET_mt7628_KN_2211 @!TARGET_mt7628_KN_2212 @!TARGET_en7512_KN_2010 @!TARGET_en7512_KN_2011 @!TARGET_en7512_KN_2012
  DISABLE_RSTRIP:=y
endef

define Package/bndstrg/install
	if [ -d ./files-bndstrg ]; then \
		$(CP) ./files-bndstrg/* $(1); \
	fi
endef

$(eval $(call BuildPackage,bndstrg))

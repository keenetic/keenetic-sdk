#
# Copyright (C) 2022 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=ltefw
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define Package/ltefw
  CATEGORY:=Base system
  TITLE:=Firmware update utility for LTE module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +libndm +libopenssl @(TARGET_mt7621_KN_2310||TARGET_mt7628_KN_2210||TARGET_mt7621_KN_2311||TARGET_mt7621_KN_2910||TARGET_mt7628_KN_2211)
  DISABLE_RSTRIP:=y
endef

define Package/ltefw/install
	if [ -d ./files-ltefw ]; then \
		$(CP) ./files-ltefw/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ltefw))

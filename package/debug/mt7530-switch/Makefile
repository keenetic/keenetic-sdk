#
# Copyright (C) 2022 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=mt7530-switch
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define Package/mt7530-switch
  CATEGORY:=Debug suite
  TITLE:=MT7530 switch configuration utility
  DEPENDS:=+libc +SSP_SUPPORT:libssp @TARGET_en7516||TARGET_en7512||TARGET_en7528||TARGET_mt7621||TARGET_mt7622_KN_1811
  DISABLE_RSTRIP:=y
endef

define Package/mt7530-switch/install
	if [ -d ./files-mt7530-switch ]; then \
		$(CP) ./files-mt7530-switch/* $(1); \
	fi
endef

$(eval $(call BuildPackage,mt7530-switch))

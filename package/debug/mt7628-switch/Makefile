#
# Copyright (C) 2023 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=mt7628-switch
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define Package/mt7628-switch
  CATEGORY:=Debug suite
  TITLE:=MT7628 switch configuration utility
  DEPENDS:=+libc +SSP_SUPPORT:libssp @TARGET_mt7628
  DISABLE_RSTRIP:=y
endef

define Package/mt7628-switch/install
	if [ -d ./files-mt7628-switch ]; then \
		$(CP) ./files-mt7628-switch/* $(1); \
	fi
endef

$(eval $(call BuildPackage,mt7628-switch))

#
# Copyright (C) 2023 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=rtl8370m-switch
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define Package/rtl8370m-switch
  CATEGORY:=Debug suite
  TITLE:=RTL8370M switch configuration utility
  DEPENDS:=+libc +SSP_SUPPORT:libssp @TARGET_mt7621_ku_rd
  DISABLE_RSTRIP:=y
endef

define Package/rtl8370m-switch/install
	if [ -d ./files-rtl8370m-switch ]; then \
		$(CP) ./files-rtl8370m-switch/* $(1); \
	fi
endef

$(eval $(call BuildPackage,rtl8370m-switch))

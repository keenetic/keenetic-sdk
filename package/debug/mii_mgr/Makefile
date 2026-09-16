#
# Copyright (C) 2026 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=mii_mgr
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define Package/mii_mgr
  CATEGORY:=Debug suite
  TITLE:=PHY MII debug utility
  DEPENDS:=+libc +SSP_SUPPORT:libssp
  DISABLE_RSTRIP:=y
endef

define Package/mii_mgr/install
	if [ -d ./files-mii_mgr ]; then \
		$(CP) ./files-mii_mgr/* $(1); \
	fi
endef

$(eval $(call BuildPackage,mii_mgr))

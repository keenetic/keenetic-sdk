#
# Copyright (C) 2022 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=dropbear
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define Package/dropbear
  CATEGORY:=Network
  TITLE:=Small SSH2 client/server
  DEPENDS:=+libc +SSP_SUPPORT:libssp +libndm +libopenssl
  DISABLE_RSTRIP:=y
endef

define Package/dropbear/install
	if [ -d ./files-dropbear ]; then \
		$(CP) ./files-dropbear/* $(1); \
	fi
endef

$(eval $(call BuildPackage,dropbear))

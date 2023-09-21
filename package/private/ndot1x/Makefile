#
# Copyright (C) 2023 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=ndot1x
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define Package/ndot1x
  CATEGORY:=Network
  TITLE:=Client for 802.1x
  DEPENDS:=+libc +SSP_SUPPORT:libssp +libndm
  DISABLE_RSTRIP:=y
endef

define Package/ndot1x/install
	if [ -d ./files-ndot1x ]; then \
		$(CP) ./files-ndot1x/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndot1x))

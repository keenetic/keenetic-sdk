#
# Copyright (C) 2023 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=coalagent
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define Package/coalagent
  CATEGORY:=Network
  TITLE:=CoAP agent
  DEPENDS:=+libc +SSP_SUPPORT:libssp +libcoala +libndm
  DISABLE_RSTRIP:=y
endef

define Package/coalagent/install
	if [ -d ./files-coalagent ]; then \
		$(CP) ./files-coalagent/* $(1); \
	fi
endef

$(eval $(call BuildPackage,coalagent))

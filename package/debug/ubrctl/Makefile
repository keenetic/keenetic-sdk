#
# Copyright (C) 2023 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=ubrctl
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define Package/ubrctl
  CATEGORY:=Debug suite
  TITLE:=uBridge Control Utility
  DEPENDS:=+libc +SSP_SUPPORT:libssp
  DISABLE_RSTRIP:=y
endef

define Package/ubrctl/install
	if [ -d ./files-ubrctl ]; then \
		$(CP) ./files-ubrctl/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ubrctl))

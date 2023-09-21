#
# Copyright (C) 2023 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=rt2860apd
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define Package/rt2860apd
  CATEGORY:=Network
  TITLE:=MediaTek WPA EAP agent
  DEPENDS:=+libc +SSP_SUPPORT:libssp
  DISABLE_RSTRIP:=y
endef

define Package/rt2860apd/install
	if [ -d ./files-rt2860apd ]; then \
		$(CP) ./files-rt2860apd/* $(1); \
	fi
endef

$(eval $(call BuildPackage,rt2860apd))

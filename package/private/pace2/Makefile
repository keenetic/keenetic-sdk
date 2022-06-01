#
# Copyright (C) 2022 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=pace2
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define Package/pace2
  CATEGORY:=Network
  TITLE:=Ipoque PACE2 R&S traffic classification engine
  DEPENDS:=+libc +SSP_SUPPORT:libssp
  DISABLE_RSTRIP:=y
endef

define Package/pace2/install
	if [ -d ./files-pace2 ]; then \
		$(CP) ./files-pace2/* $(1); \
	fi
endef

$(eval $(call BuildPackage,pace2))

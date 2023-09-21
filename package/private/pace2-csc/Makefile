#
# Copyright (C) 2023 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=pace2-csc
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define Package/pace2-csc
  CATEGORY:=Network
  TITLE:=Ipoque PACE2 custom service classifier plugin
  DEPENDS:=+libc +SSP_SUPPORT:libssp +pace2
  DISABLE_RSTRIP:=y
endef

define Package/pace2-csc/install
	if [ -d ./files-pace2-csc ]; then \
		$(CP) ./files-pace2-csc/* $(1); \
	fi
endef

$(eval $(call BuildPackage,pace2-csc))

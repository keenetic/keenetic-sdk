#
# Copyright (C) 2023 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=radvd
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define Package/radvd
  CATEGORY:=IPv6
  TITLE:=Router advertisement daemon
  DEPENDS:=+libc +SSP_SUPPORT:libssp
  DISABLE_RSTRIP:=y
endef

define Package/radvd/install
	if [ -d ./files-radvd ]; then \
		$(CP) ./files-radvd/* $(1); \
	fi
endef

$(eval $(call BuildPackage,radvd))

#
# Copyright (C) 2022 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=rdisc6d
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define Package/rdisc6d
  CATEGORY:=IPv6
  TITLE:=Router advertisement discovery
  DEPENDS:=+libc +SSP_SUPPORT:libssp +libndm
  DISABLE_RSTRIP:=y
endef

define Package/rdisc6d/install
	if [ -d ./files-rdisc6d ]; then \
		$(CP) ./files-rdisc6d/* $(1); \
	fi
endef

$(eval $(call BuildPackage,rdisc6d))

#
# Copyright (C) 2022 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=dhcpv6
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define Package/dhcpv6
  CATEGORY:=IPv6
  TITLE:=DHCPv6 server
  DEPENDS:=+libc +SSP_SUPPORT:libssp +libndm
  DISABLE_RSTRIP:=y
endef

define Package/dhcpv6/install
	if [ -d ./files-dhcpv6 ]; then \
		$(CP) ./files-dhcpv6/* $(1); \
	fi
endef

$(eval $(call BuildPackage,dhcpv6))

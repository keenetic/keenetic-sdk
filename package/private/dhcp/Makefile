#
# Copyright (C) 2023 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=dhcp
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define Package/dhcp
  CATEGORY:=Base system
  TITLE:=DHCP client + server
  DEPENDS:=+libc +SSP_SUPPORT:libssp +libndm
  DISABLE_RSTRIP:=y
endef

define Package/dhcp/install
	if [ -d ./files-dhcp ]; then \
		$(CP) ./files-dhcp/* $(1); \
	fi
endef

$(eval $(call BuildPackage,dhcp))

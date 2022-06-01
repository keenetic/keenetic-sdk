#
# Copyright (C) 2022 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=opkg_led_ctl
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define Package/opkg_led_ctl
  CATEGORY:=Base system
  TITLE:=OPKG LED control utility
  DEPENDS:=+libc +SSP_SUPPORT:libssp +kmod-phr
  DISABLE_RSTRIP:=y
endef

define Package/opkg_led_ctl/install
	if [ -d ./files-opkg_led_ctl ]; then \
		$(CP) ./files-opkg_led_ctl/* $(1); \
	fi
endef

$(eval $(call BuildPackage,opkg_led_ctl))

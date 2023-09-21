#
# Copyright (C) 2023 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=reboot
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define Package/reboot
  CATEGORY:=Base system
  TITLE:=Safe reboot utility for NDM
  DEPENDS:=+libc +SSP_SUPPORT:libssp
  DISABLE_RSTRIP:=y
endef

define Package/reboot/install
	if [ -d ./files-reboot ]; then \
		$(CP) ./files-reboot/* $(1); \
	fi
endef

$(eval $(call BuildPackage,reboot))

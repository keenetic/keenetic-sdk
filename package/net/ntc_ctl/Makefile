#
# Copyright (C) 2022 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=ntc_ctl
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define Package/ntc_ctl
  CATEGORY:=Debug suite
  TITLE:=Simple traffic control utility
  DEPENDS:=+libc +SSP_SUPPORT:libssp +kmod-ntc
  DISABLE_RSTRIP:=y
endef

define Package/ntc_ctl/install
	if [ -d ./files-ntc_ctl ]; then \
		$(CP) ./files-ntc_ctl/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ntc_ctl))

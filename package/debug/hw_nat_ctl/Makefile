#
# Copyright (C) 2023 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=hw_nat_ctl
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define Package/hw_nat_ctl
  CATEGORY:=Debug suite
  TITLE:=HW NAT control utility
  DEPENDS:=+libc +SSP_SUPPORT:libssp @HAS_HWNAT
  DISABLE_RSTRIP:=y
endef

define Package/hw_nat_ctl/install
	if [ -d ./files-hw_nat_ctl ]; then \
		$(CP) ./files-hw_nat_ctl/* $(1); \
	fi
endef

$(eval $(call BuildPackage,hw_nat_ctl))

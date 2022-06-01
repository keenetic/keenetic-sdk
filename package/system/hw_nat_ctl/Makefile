#
# Copyright (C) 2022 Keenetic Limited
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
  CATEGORY:=Base system
  TITLE:=HW NAT control utility
  DEPENDS:=+libc +SSP_SUPPORT:libssp +(TARGET_mt7621||TARGET_mt7622):kmod-mtk-hwnat +(TARGET_en7512||TARGET_en7516||TARGET_en7528):kmod-en-hwnat @!TARGET_mt7628
  DISABLE_RSTRIP:=y
endef

define Package/hw_nat_ctl/install
	if [ -d ./files-hw_nat_ctl ]; then \
		$(CP) ./files-hw_nat_ctl/* $(1); \
	fi
endef

$(eval $(call BuildPackage,hw_nat_ctl))

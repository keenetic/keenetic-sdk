#
# Copyright (C) 2022 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=mtk-hwnat
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define KernelPackage/mtk-hwnat
  SUBMENU:=Network Support
  CATEGORY:=Kernel modules
  TITLE:=Mediatek Hardware NAT
  KCONFIG:=CONFIG_RA_HW_NAT
  DEPENDS:=@TARGET_mt7621||TARGET_mt7622
  DISABLE_RSTRIP:=y
endef

define KernelPackage/mtk-hwnat/install
	if [ -d ./files-mtk-hwnat ]; then \
		$(CP) ./files-mtk-hwnat/* $(1); \
	fi
endef

$(eval $(call KernelPackage,mtk-hwnat))

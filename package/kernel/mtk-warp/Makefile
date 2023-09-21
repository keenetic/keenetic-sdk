#
# Copyright (C) 2023 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=mtk-warp
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define KernelPackage/mtk-warp
  SUBMENU:=Wireless
  CATEGORY:=Kernel modules
  TITLE:=MediaTek WARP v2 driver
  KCONFIG:=CONFIG_MTK_WARP CONFIG_FW_LOADER=y
  DEPENDS:=@HAS_WARP
  DISABLE_RSTRIP:=y
endef

define KernelPackage/mtk-warp/install
	if [ -d ./files-mtk-warp ]; then \
		$(CP) ./files-mtk-warp/* $(1); \
	fi
endef

$(eval $(call KernelPackage,mtk-warp))

#
# Copyright (C) 2023 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=mtk-conninfra
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define KernelPackage/mtk-conninfra
  SUBMENU:=Wireless
  CATEGORY:=Kernel modules
  TITLE:=MediaTek infrastructure connectivity driver
  KCONFIG:=CONFIG_MTK_CONNINFRA
  DEPENDS:=@HAS_CONNINFRA
  DISABLE_RSTRIP:=y
endef

define KernelPackage/mtk-conninfra/install
	if [ -d ./files-mtk-conninfra ]; then \
		$(CP) ./files-mtk-conninfra/* $(1); \
	fi
endef

$(eval $(call KernelPackage,mtk-conninfra))

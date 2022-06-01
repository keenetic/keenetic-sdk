#
# Copyright (C) 2022 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=btmtk_uart
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define KernelPackage/btmtk_uart
  SUBMENU:=Wireless
  CATEGORY:=Kernel modules
  TITLE:=MediaTek Bluetooth UART driver
  KCONFIG:=CONFIG_FW_LOADER=y CONFIG_CRC16=y CONFIG_BT=m CONFIG_BT_BREDR=y CONFIG_BT_HS=n CONFIG_BT_LE=y
  DEPENDS:=@HAS_MT7915_RADIO
  DISABLE_RSTRIP:=y
endef

define KernelPackage/btmtk_uart/install
	if [ -d ./files-btmtk_uart ]; then \
		$(CP) ./files-btmtk_uart/* $(1); \
	fi
endef

$(eval $(call KernelPackage,btmtk_uart))

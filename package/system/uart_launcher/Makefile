#
# Copyright (C) 2023 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=uart_launcher
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define Package/uart_launcher
  CATEGORY:=Utilities
  TITLE:=Launcher for MTK Bluetooth UART driver
  DEPENDS:=+libc +SSP_SUPPORT:libssp +kmod-btmtk_uart
  DISABLE_RSTRIP:=y
endef

define Package/uart_launcher/install
	if [ -d ./files-uart_launcher ]; then \
		$(CP) ./files-uart_launcher/* $(1); \
	fi
endef

$(eval $(call BuildPackage,uart_launcher))

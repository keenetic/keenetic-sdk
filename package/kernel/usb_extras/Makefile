#
# Copyright (C) 2026 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=usb_extras
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define KernelPackage/usb_extras
  SUBMENU:=USB Support
  CATEGORY:=Kernel modules
  TITLE:=Special USB hub hooks and extentions
  DEPENDS:=+kmod-usb-core
  DISABLE_RSTRIP:=y
endef

define KernelPackage/usb_extras/install
	if [ -d ./files-usb_extras ]; then \
		$(CP) ./files-usb_extras/* $(1); \
	fi
endef

$(eval $(call KernelPackage,usb_extras))

#
# Copyright (C) 2023 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=fastvpn
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define KernelPackage/fastvpn
  SUBMENU:=Other modules
  CATEGORY:=Kernel modules
  TITLE:=Kernel module for FastVPN
  DEPENDS:=+kmod-bridge +kmod-ubridge
  DISABLE_RSTRIP:=y
endef

define KernelPackage/fastvpn/install
	if [ -d ./files-fastvpn ]; then \
		$(CP) ./files-fastvpn/* $(1); \
	fi
endef

$(eval $(call KernelPackage,fastvpn))

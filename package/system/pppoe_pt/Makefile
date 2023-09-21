#
# Copyright (C) 2023 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=pppoe_pt
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define KernelPackage/pppoe_pt
  SUBMENU:=Other modules
  CATEGORY:=Kernel modules
  TITLE:=PPPOE passthrough module
  DISABLE_RSTRIP:=y
endef

define KernelPackage/pppoe_pt/install
	if [ -d ./files-pppoe_pt ]; then \
		$(CP) ./files-pppoe_pt/* $(1); \
	fi
endef

$(eval $(call KernelPackage,pppoe_pt))

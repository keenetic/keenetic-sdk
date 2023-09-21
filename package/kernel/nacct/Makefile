#
# Copyright (C) 2023 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=nacct
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define KernelPackage/nacct
  SUBMENU:=Network Support
  CATEGORY:=Kernel modules
  TITLE:=Traffic accouting module for netfilter conntrack
  DISABLE_RSTRIP:=y
endef

define KernelPackage/nacct/install
	if [ -d ./files-nacct ]; then \
		$(CP) ./files-nacct/* $(1); \
	fi
endef

$(eval $(call KernelPackage,nacct))

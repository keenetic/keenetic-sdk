#
# Copyright (C) 2023 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=igmpsn
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define KernelPackage/igmpsn
  SUBMENU:=Other modules
  CATEGORY:=Kernel modules
  TITLE:=IGMP Snooping module
  DISABLE_RSTRIP:=y
endef

define KernelPackage/igmpsn/install
	if [ -d ./files-igmpsn ]; then \
		$(CP) ./files-igmpsn/* $(1); \
	fi
endef

$(eval $(call KernelPackage,igmpsn))

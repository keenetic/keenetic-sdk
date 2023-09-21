#
# Copyright (C) 2023 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=resetnds
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define KernelPackage/resetnds
  SUBMENU:=Other modules
  CATEGORY:=Kernel modules
  TITLE:=Network device statistics reset
  DEPENDS:=+kmod-ubridge
  DISABLE_RSTRIP:=y
endef

define KernelPackage/resetnds/install
	if [ -d ./files-resetnds ]; then \
		$(CP) ./files-resetnds/* $(1); \
	fi
endef

$(eval $(call KernelPackage,resetnds))

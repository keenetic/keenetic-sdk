#
# Copyright (C) 2022 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=br2684vlan
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define KernelPackage/br2684vlan
  SUBMENU:=Network Support
  CATEGORY:=Kernel modules
  TITLE:=RFC2684 to VLAN bridge
  DEPENDS:=kmod-mt-vdsl-driver
  DISABLE_RSTRIP:=y
endef

define KernelPackage/br2684vlan/install
	if [ -d ./files-br2684vlan ]; then \
		$(CP) ./files-br2684vlan/* $(1); \
	fi
endef

$(eval $(call KernelPackage,br2684vlan))

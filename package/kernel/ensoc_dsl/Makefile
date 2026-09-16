#
# Copyright (C) 2026 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=ensoc_dsl
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define KernelPackage/ensoc_dsl
  SUBMENU:=Network Support
  CATEGORY:=Kernel modules
  TITLE:=xDSL drivers for Econet chips
  DEPENDS:=@TARGET_en7512||TARGET_en7516 +kmod-phr
  DISABLE_RSTRIP:=y
endef

define KernelPackage/ensoc_dsl/install
	if [ -d ./files-ensoc_dsl ]; then \
		$(CP) ./files-ensoc_dsl/* $(1); \
	fi
endef

$(eval $(call KernelPackage,ensoc_dsl))

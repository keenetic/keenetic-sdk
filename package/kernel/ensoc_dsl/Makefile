#
# Copyright (C) 2022 Keenetic Limited
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
  DEPENDS:=@TARGET_en7512_KN_2010||TARGET_en7512_KN_2011||TARGET_en7512_KN_2012||TARGET_en7512_KN_2110||TARGET_en7512_KN_2111||TARGET_en7516_KN_2112||TARGET_en7516_KN_2410||TARGET_en7516_KN_2510||TARGET_en7516_KN_3610 +kmod-phr
  DISABLE_RSTRIP:=y
endef

define KernelPackage/ensoc_dsl/install
	if [ -d ./files-ensoc_dsl ]; then \
		$(CP) ./files-ensoc_dsl/* $(1); \
	fi
endef

$(eval $(call KernelPackage,ensoc_dsl))

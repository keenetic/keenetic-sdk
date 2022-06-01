#
# Copyright (C) 2022 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=mt-vdsl
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define KernelPackage/mt-vdsl-driver
  SUBMENU:=Network Support
  CATEGORY:=Kernel modules
  TITLE:=Drivers for Metanoia VDSL2
  DISABLE_RSTRIP:=y
endef

define KernelPackage/mt-vdsl-driver/install
	if [ -d ./files-mt-vdsl-driver ]; then \
		$(CP) ./files-mt-vdsl-driver/* $(1); \
	fi
endef

$(eval $(call KernelPackage,mt-vdsl-driver))

define Package/mt-vdsl-cli
  CATEGORY:=Network
  TITLE:=Metanoia VDSL utils and firmware
  DEPENDS:=+libc +SSP_SUPPORT:libssp +kmod-mt-vdsl-driver
  DISABLE_RSTRIP:=y
endef

define Package/mt-vdsl-cli/config
	select PACKAGE_kmod-mt-vdsl-driver
endef

define Package/mt-vdsl-cli/install
	if [ -d ./files-mt-vdsl-cli ]; then \
		$(CP) ./files-mt-vdsl-cli/* $(1); \
	fi
endef

$(eval $(call BuildPackage,mt-vdsl-cli))

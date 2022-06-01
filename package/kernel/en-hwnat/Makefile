#
# Copyright (C) 2022 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=en-hwnat
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define KernelPackage/en-hwnat
  SUBMENU:=Network Support
  CATEGORY:=Kernel modules
  TITLE:=EcoNet Hardware NAT
  KCONFIG:=CONFIG_RA_HW_NAT
  DEPENDS:=@TARGET_en7512||TARGET_en7516||TARGET_en7528
  DISABLE_RSTRIP:=y
endef

define KernelPackage/en-hwnat/install
	if [ -d ./files-en-hwnat ]; then \
		$(CP) ./files-en-hwnat/* $(1); \
	fi
endef

$(eval $(call KernelPackage,en-hwnat))

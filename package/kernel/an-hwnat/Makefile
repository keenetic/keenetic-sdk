#
# Copyright (C) 2026 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=an-hwnat
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define KernelPackage/an-hwnat
  SUBMENU:=Network Support
  CATEGORY:=Kernel modules
  TITLE:=Airoha Hardware NAT
  KCONFIG:=CONFIG_RA_HW_NAT
  DEPENDS:=@TARGET_an7552||TARGET_an7581
  DISABLE_RSTRIP:=y
endef

define KernelPackage/an-hwnat/install
	if [ -d ./files-an-hwnat ]; then \
		$(CP) ./files-an-hwnat/* $(1); \
	fi
endef

$(eval $(call KernelPackage,an-hwnat))

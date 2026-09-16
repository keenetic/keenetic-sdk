#
# Copyright (C) 2026 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=an-npu
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define KernelPackage/an-npu
  SUBMENU:=Network Support
  CATEGORY:=Kernel modules
  TITLE:=Airoha NPU host driver
  KCONFIG:=CONFIG_FW_LOADER=y
  DEPENDS:=@TARGET_an7552||TARGET_an7581
  DISABLE_RSTRIP:=y
endef

define KernelPackage/an-npu/install
	if [ -d ./files-an-npu ]; then \
		$(CP) ./files-an-npu/* $(1); \
	fi
endef

$(eval $(call KernelPackage,an-npu))

#
# Copyright (C) 2022 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=ntc
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define KernelPackage/ntc
  SUBMENU:=Other modules
  CATEGORY:=Kernel modules
  TITLE:=Simple traffic control driver
  DISABLE_RSTRIP:=y
endef

define KernelPackage/ntc/install
	if [ -d ./files-ntc ]; then \
		$(CP) ./files-ntc/* $(1); \
	fi
endef

$(eval $(call KernelPackage,ntc))

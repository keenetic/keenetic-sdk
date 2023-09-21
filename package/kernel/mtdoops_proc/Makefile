#
# Copyright (C) 2023 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=mtdoops_proc
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define KernelPackage/mtdoops_proc
  SUBMENU:=Other modules
  CATEGORY:=Kernel modules
  TITLE:=Proc access to MTD crash dumps
  DISABLE_RSTRIP:=y
endef

define KernelPackage/mtdoops_proc/install
	if [ -d ./files-mtdoops_proc ]; then \
		$(CP) ./files-mtdoops_proc/* $(1); \
	fi
endef

$(eval $(call KernelPackage,mtdoops_proc))

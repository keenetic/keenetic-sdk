#
# Copyright (C) 2021 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=ntce-nf
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define KernelPackage/ntce-nf
  SUBMENU:=Other modules
  CATEGORY:=Kernel modules
  TITLE:=NTCE netfilter hook
  KCONFIG:=CONFIG_NTCE_MODULE=y
  DISABLE_RSTRIP:=y
endef

define KernelPackage/ntce-nf/install
	if [ -d ./files-ntce-nf ]; then \
		$(CP) ./files-ntce-nf/* $(1); \
	fi
endef

$(eval $(call KernelPackage,ntce-nf))

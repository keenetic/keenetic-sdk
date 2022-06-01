#
# Copyright (C) 2022 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=nnfm
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define KernelPackage/nnfm
  SUBMENU:=Other modules
  CATEGORY:=Kernel modules
  TITLE:=NTCE netfilter flow marker
  KCONFIG:=CONFIG_NTCE_MODULE=y CONFIG_NF_CONNTRACK_EVENTS=y
  DISABLE_RSTRIP:=y
endef

define KernelPackage/nnfm/install
	if [ -d ./files-nnfm ]; then \
		$(CP) ./files-nnfm/* $(1); \
	fi
endef

$(eval $(call KernelPackage,nnfm))

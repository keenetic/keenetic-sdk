#
# Copyright (C) 2021 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=ipt-netflow
PKG_VERSION:=2.4-0
PKG_RELEASE:=1

PKG_SOURCE_URL:=$(NDM_STORAGE)/$(PKG_NAME)
PKG_SOURCE_VERSION:=$(PKG_VERSION)
PKG_SOURCE_PROTO:=git

PKG_LICENSE_FILES:=CREDITS

include $(INCLUDE_DIR)/package.mk

define Build/Configure
endef

define KernelPackage/ipt-netflow
	SUBMENU:=Other modules
	TITLE:=Netflow netfilter module for Linux kernel
	URL:=https://github.com/aabc/ipt-netflow
	FILES:=$(PKG_BUILD_DIR)/ipt_NETFLOW.ko
endef

define Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR) version
	+$(KERNEL_MAKE) $(PKG_JOBS) \
		M="$(PKG_BUILD_DIR)" \
		KDIR="$(LINUX_DIR)" \
		SUBDIRS="$(PKG_BUILD_DIR)" \
		PLATFORM="$(ARCH_PACKAGES)" \
		modules
endef

$(eval $(call KernelPackage,ipt-netflow))

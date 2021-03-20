#
# Copyright (C) 2021 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=nf-nathelper-rtsp
PKG_VERSION:=5.3-ndm-1
PKG_LICENSE:=GPL-2.0+

PKG_SOURCE_URL:=$(NDM_STORAGE)/$(PKG_NAME)
PKG_SOURCE_VERSION:=$(PKG_VERSION)
PKG_SOURCE_PROTO:=git

include $(INCLUDE_DIR)/package.mk

define KernelPackage/$(PKG_NAME)
  SUBMENU:=Netfilter Extensions
  TITLE:=RTSP Conntrack and NAT helpers
  URL:=https://github.com/maru-sama/rtsp-linux
  FILES:=$(PKG_BUILD_DIR)/nf_nat_rtsp.ko \
         $(PKG_BUILD_DIR)/nf_conntrack_rtsp.ko
endef

define KernelPackage/$(PKG_NAME)/description
 Extra Netfilter (IPv4) Conntrack and NAT helpers
 Includes:
 - rtsp
endef

define Build/Compile
	+$(KERNEL_MAKE) $(PKG_JOBS) \
		M="$(PKG_BUILD_DIR)" \
		modules
endef

$(eval $(call KernelPackage,$(PKG_NAME)))

#
# Copyright (C) 2024 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=fs-ntfs3
PKG_VERSION:=5.15-0

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/keenetic/ntfs3.git
PKG_SOURCE_VERSION:=$(PKG_VERSION)

PKG_MAINTAINER:=
PKG_LICENSE:=GPL-2.0-only

include $(INCLUDE_DIR)/package.mk

define KernelPackage/$(PKG_NAME)
  SECTION:=kernel
  CATEGORY:=Kernel modules
  SUBMENU:=Filesystems
  TITLE:=Kernel module for NTFS Read-Write file system support
  FILES:=$(PKG_BUILD_DIR)/ntfs3.ko
  AUTOLOAD:=$(call AutoProbe,ntfs3)
  DEPENDS:=+kmod-nls-base +kmod-nls-utf8
endef

define KernelPackage/$(PKG_NAME)/description
  This package provides the kernel module for ntfs3.
endef

define Build/Compile
	$(KERNEL_MAKE) M="$(PKG_BUILD_DIR)" \
	EXTRA_CFLAGS="$(EXTRA_CFLAGS)" \
	$(PKG_EXTRA_KCONFIG) \
	CONFIG_NTFS3_FS=m \
	CONFIG_NTFS3_LZX_XPRESS=y \
	CONFIG_NTFS3_FS_POSIX_ACL=n \
	modules
endef

$(eval $(call KernelPackage,$(PKG_NAME)))

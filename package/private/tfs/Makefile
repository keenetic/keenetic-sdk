#
# Copyright (C) 2022 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=tfs
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define KernelPackage/tfat
  SUBMENU:=Filesystems
  CATEGORY:=Kernel modules
  TITLE:=Tuxera VFAT driver
  DEPENDS:=+kmod-nls-base
  DISABLE_RSTRIP:=y
endef

define KernelPackage/tfat/install
	if [ -d ./files-tfat ]; then \
		$(CP) ./files-tfat/* $(1); \
	fi
endef

$(eval $(call KernelPackage,tfat))

define KernelPackage/thfsplus
  SUBMENU:=Filesystems
  CATEGORY:=Kernel modules
  TITLE:=Tuxera HFS+ driver
  DEPENDS:=+kmod-nls-base
  DISABLE_RSTRIP:=y
endef

define KernelPackage/thfsplus/install
	if [ -d ./files-thfsplus ]; then \
		$(CP) ./files-thfsplus/* $(1); \
	fi
endef

$(eval $(call KernelPackage,thfsplus))

define KernelPackage/tntfs
  SUBMENU:=Filesystems
  CATEGORY:=Kernel modules
  TITLE:=Tuxera NTFS driver
  DEPENDS:=+kmod-nls-base
  DISABLE_RSTRIP:=y
endef

define KernelPackage/tntfs/install
	if [ -d ./files-tntfs ]; then \
		$(CP) ./files-tntfs/* $(1); \
	fi
endef

$(eval $(call KernelPackage,tntfs))

define Package/tntfs-utils
  SUBMENU:=Filesystem
  CATEGORY:=Utilities
  TITLE:=Tuxera NTFS driver utilities
  DEPENDS:=+libc +SSP_SUPPORT:libssp +kmod-tntfs
  DISABLE_RSTRIP:=y
endef

define Package/tntfs-utils/install
	if [ -d ./files-tntfs-utils ]; then \
		$(CP) ./files-tntfs-utils/* $(1); \
	fi
endef

$(eval $(call BuildPackage,tntfs-utils))

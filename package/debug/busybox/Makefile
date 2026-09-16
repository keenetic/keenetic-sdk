# SPDX-License-Identifier: GPL-2.0-or-later
#
# Copyright (C) 2006-2021 OpenWrt.org
include $(TOPDIR)/rules.mk

PKG_NAME:=busybox
PKG_VERSION:=1.37.0
PKG_RELEASE:=5
PKG_FLAGS:=essential

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.bz2
PKG_SOURCE_URL:=https://www.busybox.net/downloads \
		https://sources.buildroot.net/$(PKG_NAME)
PKG_HASH:=3311dff32e746499f4df0d5df04d7eb396382d7e108bb9250e7b519b837043a4

PKG_EPOCH:=1
PKG_LICENSE:=GPL-2.0
PKG_LICENSE_FILES:=LICENSE archival/libarchive/bz/LICENSE
PKG_CPE_ID:=cpe:/a:busybox:busybox

include $(INCLUDE_DIR)/package.mk

ifneq ($(findstring c,$(OPENWRT_VERBOSE)),)
  BB_MAKE_VERBOSE := V=1
else
  BB_MAKE_VERBOSE :=
endif

define Package/busybox
  SECTION:=debug
  CATEGORY:=Debug suite
  MAINTAINER:=Felix Fietkau <nbd@nbd.name>
  DEPENDS:=+USE_GLIBC:libxcrypt
  TITLE:=Core utilities for embedded Linux
  URL:=http://busybox.net/
endef

define Package/busybox/description
 The Swiss Army Knife of embedded Linux.
 It slices, it dices, it makes Julian Fries.
endef

# don't create a version string containing the actual timestamp
export KCONFIG_NOTIMESTAMP=1

define Build/Configure
	rm -f $(PKG_BUILD_DIR)/.configured*
	cp -f configs/debug.config $(PKG_BUILD_DIR)/.config
	yes 'n' | $(MAKE) -C $(PKG_BUILD_DIR) \
		CC="$(TARGET_CC)" \
		CROSS_COMPILE="$(TARGET_CROSS)" \
		KBUILD_HAVE_NLS=no \
		ARCH="$(ARCH)" \
		$(BB_MAKE_VERBOSE) \
		oldconfig
endef

LDLIBS:=m crypt

define Build/Compile
	+$(MAKE) $(PKG_JOBS) -C $(PKG_BUILD_DIR) \
		CC="$(TARGET_CC)" \
		CROSS_COMPILE="$(TARGET_CROSS)" \
		KBUILD_HAVE_NLS=no \
		EXTRA_CFLAGS="$(TARGET_CFLAGS)" \
		EXTRA_LDFLAGS="$(TARGET_LDFLAGS)" \
		ARCH="$(ARCH)" \
		SKIP_STRIP=y \
		LDLIBS="$(LDLIBS)" \
		$(BB_MAKE_VERBOSE) \
		all
	rm -rf $(PKG_INSTALL_DIR)
	$(FIND) $(PKG_BUILD_DIR) -lname "*busybox" -exec rm \{\} \;
	$(MAKE) -C $(PKG_BUILD_DIR) \
		CC="$(TARGET_CC)" \
		CROSS_COMPILE="$(TARGET_CROSS)" \
		EXTRA_CFLAGS="$(TARGET_CFLAGS)" \
		EXTRA_LDFLAGS="$(TARGET_LDFLAGS)" \
		ARCH="$(ARCH)" \
		CONFIG_PREFIX="$(PKG_INSTALL_DIR)" \
		LDLIBS="$(LDLIBS)" \
		$(BB_MAKE_VERBOSE) \
		install
endef

define Package/busybox/install
	$(INSTALL_DIR) $(1)/etc
	sed 's/DEV_CONSOLE/$(call qstrip,$(CONFIG_TARGET_DEV_CONSOLE))/' <./files/inittab >$(1)/etc/inittab

	$(CP) $(PKG_INSTALL_DIR)/* $(1)/
	-rm -rf $(1)/lib64
endef

$(eval $(call BuildPackage,busybox))

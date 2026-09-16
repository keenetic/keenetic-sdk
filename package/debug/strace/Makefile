#
# Copyright (C) 2006-2012 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=strace

PKG_VERSION:=5.10
PKG_RELEASE:=1
PKG_MD5SUM:=8d7eb10eba68bad83a269197e634b626

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.xz
PKG_SOURCE_URL:=https://strace.io/files/$(PKG_VERSION)
PKG_HASH:=fe3982ea4cd9aeb3b4ba35f6279f0b577a37175d3282be24b9a5537b56b8f01c

PKG_LICENSE:=BSD-3c
PKG_LICENSE_FILES:=COPYING

PKG_FIXUP:=autoreconf
PKG_INSTALL:=1

include $(INCLUDE_DIR)/package.mk

ifeq ($(ARCH),aarch64)
  CONFIGURE_ARGS += --enable-mpers=check
endif

define Package/strace
  SECTION:=debug
  CATEGORY:=Debug suite
  TITLE:=System call tracer
  DEPENDS:=+libunwind-arch +libunwind-ptrace +librt
  URL:=http://strace.sourceforge.net/
endef

define Package/strace/description
A useful diagnostic, instructional, and debugging tool. Allows you to track what
system calls a program makes while it is running.
endef

CONFIGURE_ARGS += --with-libunwind=yes
MAKE_FLAGS := \
	CCOPT="$(TARGET_CFLAGS)"

define Package/strace/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/strace $(1)/usr/bin/
endef

$(eval $(call BuildPackage,strace))

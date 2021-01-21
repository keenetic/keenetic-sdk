#
# Copyright (C) 2021 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/libndmfw.mk

PKG_NAME:=libucontext
PKG_VERSION:=$(PKG_NAME)-0.12
PKG_LICENSE:=Unique
PKG_LICENSE_FILES:=LICENSE

PKG_SOURCE:=$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://github.com/kaniini/libucontext/archive/
PKG_HASH:=84583caa7e4d8c1fb630e1166b47f7e5b5336de522d7e3951bd902f353f7a7e2

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  SECTION:=libs
  CATEGORY:=Libraries
  TITLE:=Libc-independent ucontext implementation
  URL:=https://github.com/kaniini/libucontext
endef

define Package/$(PKG_NAME)/description
 libucontext is a library which provides the ucontext.h C API. Unlike other implementations,
 it faithfully follows the kernel process ABI when doing context swaps.
endef

ifeq ($(ARCH),mipsel)
  LIBUCONTEXT_ARCH:=mips
else
  LIBUCONTEXT_ARCH:=$(ARCH)
endif

MAKE_FLAGS = \
	$(TARGET_CONFIGURE_OPTS) \
	CROSS="$(TARGET_CROSS)" \
	ARCH="$(LIBUCONTEXT_ARCH)"

define Build/InstallDev
	$(INSTALL_DIR) $(1)/lib
	$(CP) $(PKG_BUILD_DIR)/libucontext.a $(1)/lib/
endef

$(eval $(call BuildPackage,$(PKG_NAME)))

#
# Copyright (C) 2006 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
# $Id: Makefile 12225 2008-08-06 22:10:29Z nbd $

include $(TOPDIR)/rules.mk

PKG_NAME:=libusb
PKG_VERSION:=1.0.19
PKG_HASH:=6c502c816002f90d4f76050a6429c3a7e0d84204222cbff2dce95dd773ba6840
PKG_RELEASE:=6

PKG_LICENSE:=LGPL-2.1

PKG_SOURCE:=libusb-$(PKG_VERSION).tar.bz2
PKG_SOURCE_URL:=@SF/libusb
PKG_BUILD_DIR:=$(BUILD_DIR)/libusb-$(PKG_VERSION)

PKG_INSTALL:=1

ifneq ($(CONFIG_USE_MKLIBS),)
  TARGET_LTO_FLAGS :=
endif

include $(INCLUDE_DIR)/package.mk

define Package/libusb
  SECTION:=libs
  CATEGORY:=Libraries
  DEPENDS:=+libpthread
  TITLE:=A library for accessing Linux USB devices
  URL:=http://libusb.info/
endef

define Package/libusb/description
  libusb is a C library that gives applications easy access to USB devices on
  many different operating systems.
endef

TARGET_CFLAGS += $(FPIC)
CONFIGURE_ARGS += --disable-udev

define Build/InstallDev
	$(CP) $(PKG_INSTALL_DIR)/* $(1)/
endef

define Package/libusb/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libusb-1.0.so* $(1)/usr/lib/
endef

define Package/libusb/install_lib
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libusb-1.0.a $(1)/usr/lib/libusb-1.0_pic.a
endef


$(eval $(call BuildPackage,libusb))

#
# Copyright (C) 2006-2013 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=libpcap
PKG_VERSION:=1.9.1
PKG_RELEASE:=1
PKG_LICENSE:=BSD

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://www.tcpdump.org/release/ \
				http://www.us.tcpdump.org/release/
PKG_HASH:=635237637c5b619bcceba91900666b64d56ecb7be63f298f601ec786ce087094

PKG_LICENSE_FILES:=LICENSE

PKG_INSTALL:=1

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/kernel.mk

define Package/libpcap
  SECTION:=libs
  CATEGORY:=Libraries
  TITLE:=Low-level packet capture library
  URL:=http://www.tcpdump.org/
  MENU:=1
endef

define Package/libpcap/description
This package contains a system-independent library for user-level
network packet capture.
endef

EXTRA_CPPFLAGS := -D_LARGEFILE_SOURCE \
                  -D_LARGEFILE64_SOURCE \
                  -D_FILE_OFFSET_BITS=64

EXTRA_CFLAGS   := $(FPIC)

EXTRA_LDFLAGS  := $(FPIC)

CONFIGURE_VARS += \
	ac_cv_linux_vers=$(LINUX_VERSION) \
	ac_cv_header_libusb_1_0_libusb_h=no \
	ac_cv_netfilter_can_compile=no

CONFIGURE_ARGS += \
	--enable-shared \
	--disable-static \
	--disable-yydebug \
	--enable-ipv6 \
	--with-pcap=linux \
	--without-septel \
	--without-dag \
	--without-libnl \
	--disable-bluetooth \
	--disable-can \
	--disable-canusb \
	--disable-dbus

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include
	$(CP) $(PKG_INSTALL_DIR)/usr/include/pcap* $(1)/usr/include/

	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libpcap.{a,so*} $(1)/usr/lib/
endef

define Package/libpcap/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libpcap.so* $(1)/usr/lib/
endef

$(eval $(call BuildPackage,libpcap))

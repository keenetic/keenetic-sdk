#
# Copyright (C) 2006-2012 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=isc-dhcp
PKG_VERSION:=4.4.3-1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=$(NDM_STORAGE)/$(PKG_NAME)

PKG_SOURCE_VERSION:=$(PKG_VERSION)

PKG_LICENSE:=BSD-3-Clause
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=Philip Prindeville <philipp@redfish-solutions.com>
PKG_CPE_ID:=cpe:/a:isc:dhcp

PKG_FIXUP:=autoreconf
PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk

DISABLE_NLS:=

define Package/isc-dhcp-server-ipv6
  SECTION:=net
  CATEGORY:=IPv6
  TITLE:=ISC's DHCP server (with IPv6)
  URL:=https://www.isc.org/software/dhcp
  DEPENDS:=@IPV6 +zlib
endef

define Package/isc-dhcp-server-ipv6/description
 implements the Dynamic Host Configuration Protocol (DHCP) and the Internet
 Bootstrap Protocol (BOOTP).
 This package is compiled with IPv6 support.
endef

CONFIGURE_ARGS += \
	--enable-dhcpv6	\
	--disable-paranoia	\
	--disable-dependency-tracking	\
	--disable-backtrace	\
	--disable-delayed-ack	\
	--disable-failover	\
	--disable-execute	\
	--disable-tracing	\
	--with-randomdev=/dev/urandom	\
	ac_cv_path_AR=$(TARGET_AR)	\
	ac_cv_file__dev_random=yes

TARGET_CFLAGS += -fcommon -Os

define Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR)			\
		BUILD_CC="$(HOSTCC_NOCACHE)"		\
		CROSS_CC="$(TARGET_CC)"			\
		host_alias="$(GNU_TARGET_NAME)"		\
		target_alias="$(GNU_TARGET_NAME)"	\
		build_alias="$(GNU_HOST_NAME)"		\
		all
	$(MAKE) -C $(PKG_BUILD_DIR)			\
		DESTDIR="$(PKG_INSTALL_DIR)"		\
		BUILD_CC="$(HOSTCC_NOCACHE)"		\
		CROSS_CC="$(TARGET_CC)"			\
		host_alias="$(GNU_TARGET_NAME)"		\
		target_alias="$(GNU_TARGET_NAME)"	\
		build_alias="$(GNU_HOST_NAME)"		\
		install-exec
endef

define Package/isc-dhcp-server-ipv6/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/sbin/dhcpd $(1)/usr/sbin
endef

$(eval $(call BuildPackage,isc-dhcp-server-ipv6))

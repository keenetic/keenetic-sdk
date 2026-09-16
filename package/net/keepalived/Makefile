#
# Copyright (C) 2006-2015 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=keepalived
PKG_VERSION:=2.3.4
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://www.keepalived.org/software
PKG_HASH:=6afd95ddb7d3e0d3b8b8e5b3a489144131b61a01b06d29e883d0c44acc8a36bf

PKG_EPOCH:=1
PKG_LICENSE:=GPL-2.0-or-later
PKG_LICENSE_FILES:=COPYING

PKG_INSTALL:=1

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/kernel.mk

define Package/keepalived
  SECTION:=net
  CATEGORY:=Network
  TITLE:=VRRP with failover
  URL:=http://www.keepalived.org/
  DEPENDS:= \
    +libnl-genl \
    +libnl-route \
    +libnfnetlink
endef

define Package/keepalived/description
 VRRP with failover and monitoring daemon for Linux Virtual Server (LVS) clusters.
endef

CONFIGURE_ARGS+= \
	--disable-json \
	--with-init=SYSV \
	--disable-track-process \
	--runstatedir="/var/run" \
	--disable-lvs \
	--disable-nftables \
	--disable-iptables \
	--disable-libipset-dynamic \
	--disable-vrrp-auth \
	--disable-checksum-compat \
	--disable-linkbeat \
	--disable-routes \
	--disable-hardening

CONFIGURE_VARS+= \
	ac_cv_have_decl___NR_close_range=no

define Package/keepalived/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/sbin/keepalived \
		$(1)/usr/sbin/
endef

$(eval $(call BuildPackage,keepalived))

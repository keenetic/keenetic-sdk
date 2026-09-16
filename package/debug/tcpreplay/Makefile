#
# Copyright (C) 2016 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=tcpreplay
PKG_VERSION:=4.4.4
PKG_RELEASE:=2

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.xz
PKG_SOURCE_URL:=https://github.com/appneta/tcpreplay/releases/download/v$(PKG_VERSION)
PKG_HASH:=3ff9753cc43bb15e77832cee657e3030dbcdd957fa247e6abacc605689e24051

PKG_LICENSE:=GPL-3.0
PKG_LICENSE_FILES:=docs/LICENSE

PKG_FIXUP:=autoreconf
PKG_BUILD_PARALLEL:=1
PKG_INSTALL:=1

include $(INCLUDE_DIR)/package.mk

TCPREPLAY_MODULES:= \
	tcpliveplay tcpreplay

define Package/tcpreplay/default
  SUBMENU:=Tcpreplay
  SECTION:=net
  CATEGORY:=Network
  URL:=http://tcpreplay.appneta.com/
  MAINTAINER:=Alexandru Ardelean <ardeleanalex@gmail.com>
  DEPENDS:=+librt +libpcap +libdnet +musl-fts
endef

define Package/tcpliveplay
$(call Package/tcpreplay/default)
  TITLE:=Replays network traffic stored in a pcap file on live networks using new TCP connections
endef

define Package/tcpreplay
$(call Package/tcpreplay/default)
  TITLE:=Replay network traffic stored in pcap files
endef

define Package/tcpreplay-all
$(call Package/tcpreplay/default)
  TITLE:=Pcap editing and replaying utilities
  DEPENDS:=$(foreach m,$(TCPREPLAY_MODULES),+$(m))
endef

define Package/tcpliveplay/description
  This program, 'tcpliveplay' replays a captured set of packets using new TCP
  connections with the captured TCP payloads against a remote host in order
  to do comprehensive vulnerability testings.
endef

define Package/tcpreplay/description
  tcpreplay is a tool for replaying network traffic from files saved with
  tcpdump or other tools which write pcap(3) files.
endef

define Package/tcpreplay-all/description
  Tcpreplay is a suite of free Open Source utilities for
  editing and replaying previously captured network traffic.
  Originally designed to replay malicious traffic patterns to
  Intrusion Detection/Prevention Systems, it has seen many evolutions
  including capabilities to replay to web servers.

  Version 4.0.0 introduces features and performance enhancements
  to support switches, routers, and IP Flow/NetFlow appliances. 
endef

ifneq ($(CONFIG_USE_MUSL),)
	TARGET_LDFLAGS+= -lfts
endif

CONFIGURE_VARS += \
	ac_cv_lib_nl_nl_cache_alloc=no \
	ac_cv_lib_nl_genl_3_genl_connect=no \
	ac_cv_lib_nl_3_nl_cache_alloc=no \
	ac_cv_lib_dbus_1_dbus_malloc=no \
	ac_cv_path_pcncfg=no

CONFIGURE_ARGS += \
	--enable-force-pf \
	--enable-dynamic-link \
	--with-libdnet="$(STAGING_DIR)/usr" \
	--with-libpcap="$(STAGING_DIR)/usr"

define tcpreplayTemplate
  define Package/$(1)/install
    $(INSTALL_DIR) $$(1)/usr/bin ; \
    $(CP) $$(PKG_INSTALL_DIR)/usr/bin/$(1) $$(1)/usr/bin
  endef
endef

define Package/tcpreplay-all/install
	:
endef

$(foreach m, $(TCPREPLAY_MODULES), \
	$(eval $(call tcpreplayTemplate,$(m))) \
	$(eval $(call BuildPackage,$(m))) \
)

$(eval $(call BuildPackage,tcpreplay-all))

#
# Copyright (C) 2021 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=accel-ppp
PKG_VERSION:=1.12-10
PKG_LICENSE:=GPL-2.0

PKG_SOURCE_URL:=$(NDM_STORAGE)/$(PKG_NAME)
PKG_SOURCE_VERSION:=$(PKG_VERSION)
PKG_SOURCE_PROTO:=git

CMAKE_BINARY_SUBDIR:=out

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

CMAKE_OPTIONS+= \
	-DBUILD_DRIVER=FALSE \
	-DCMAKE_BUILD_TYPE=Release \
	-DLOG_PGSQL=FALSE \
	-DSHAPER=FALSE \
	-DRADIUS=FALSE \
	-DNETSNMP=FALSE \
	-DVLANMON=FALSE \
	-DPPTPCTRL=TRUE \
	-DPPPOECTRL=TRUE \
	-DIPOECTRL=FALSE \
	-DL2TPCTRL=TRUE \
	-DSSTPCTRL=TRUE \
	-DLOG_FILE=FALSE \
	-DLOG_TCP=FALSE \
	-DLOG_SYSLOG=TRUE \
	-DIPV6=TRUE

define Package/accel-ppp
  SECTION:=net
  CATEGORY:=Network
  DEPENDS:=\
	+libopenssl \
	+librt \
	+ACCEL_PPP_BACKTRACE:libfatalsig \
	+USE_MUSL:libucontext
  TITLE:=High performance accel-ppp VPN server
  URL:=https://accel-ppp.org/
  SUBMENU:=VPN
endef

define Package/accel-ppp-l2tp
  SECTION:=net
  CATEGORY:=Network
  DEPENDS:=+kmod-pppol2tp-kernel +accel-ppp
  TITLE:=L2TP plugin for accel-ppp
  URL:=https://accel-ppp.org/
  SUBMENU:=VPN
endef

define Package/accel-ppp-sstp
  SECTION:=net
  CATEGORY:=Network
  DEPENDS:=+accel-ppp
  TITLE:=SSTP plugin for accel-ppp
  URL:=https://accel-ppp.org/
  SUBMENU:=VPN
endef

define Package/accel-ppp-pptp
  SECTION:=net
  CATEGORY:=Network
  DEPENDS:=+kmod-pptp +kmod-mppe +accel-ppp
  TITLE:=PPTP plugin for accel-ppp
  URL:=https://accel-ppp.org/
  SUBMENU:=VPN
endef

define Package/accel-ppp-pppoe
  SECTION:=net
  CATEGORY:=Network
  DEPENDS:=+kmod-pppoe +accel-ppp
  TITLE:=PPPoE plugin for accel-ppp
  URL:=https://accel-ppp.org/
  SUBMENU:=VPN
endef

define Package/accel-ppp/config
	source "$(SOURCE)/accel-ppp.in"
endef

ifeq ($(CONFIG_ACCEL_PPP_BACKTRACE),y)
TARGET_CFLAGS   := $(filter-out \
                     -fno-asynchronous-unwind-tables \
                     -fomit-frame-pointer \
                     -fno-caller-saves \
                   , $(TARGET_CFLAGS)) \
                  -fasynchronous-unwind-tables \
                  -fno-omit-frame-pointer \
                  -fcaller-saves
RSTRIP         := :
STRIP          := :
CMAKE_OPTIONS+= -DFATALSIG_BACKTRACE=TRUE
else
CMAKE_OPTIONS+= -DFATALSIG_BACKTRACE=FALSE
endif

define Package/accel-ppp/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_DIR) $(1)/usr/lib/accel-ppp

	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/sbin/accel-pppd $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/lib/accel-ppp/libauth_mschap_v2.so $(1)/usr/lib/accel-ppp
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/lib/accel-ppp/libauth_pap.so $(1)/usr/lib/accel-ppp
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/lib/accel-ppp/libchap-secrets.so $(1)/usr/lib/accel-ppp
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/lib/accel-ppp/libippool.so $(1)/usr/lib/accel-ppp
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/lib/accel-ppp/liblog_syslog.so $(1)/usr/lib/accel-ppp
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/lib/accel-ppp/libpppd_compat.so $(1)/usr/lib/accel-ppp
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/lib/accel-ppp/libsigchld.so $(1)/usr/lib/accel-ppp
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/lib/accel-ppp/libtriton.so $(1)/usr/lib/accel-ppp
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/lib/accel-ppp/libipv6_nd.so $(1)/usr/lib/accel-ppp
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/lib/accel-ppp/libipv6_dhcp.so $(1)/usr/lib/accel-ppp
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/lib/accel-ppp/libipv6pool.so $(1)/usr/lib/accel-ppp
endef

define Package/accel-ppp-l2tp/install
	$(INSTALL_DIR) $(1)/usr/lib/accel-ppp
	$(INSTALL_DIR) $(1)/usr/share/accel-ppp/l2tp

	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/lib/accel-ppp/libl2tp.so $(1)/usr/lib/accel-ppp
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/share/accel-ppp/l2tp/dict* $(1)/usr/share/accel-ppp/l2tp
endef

define Package/accel-ppp-sstp/install
	$(INSTALL_DIR) $(1)/usr/lib/accel-ppp

	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/lib/accel-ppp/libsstp.so $(1)/usr/lib/accel-ppp
endef

define Package/accel-ppp-pptp/install
	$(INSTALL_DIR) $(1)/usr/lib/accel-ppp

	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/lib/accel-ppp/libpptp.so $(1)/usr/lib/accel-ppp
endef

define Package/accel-ppp-pppoe/install
	$(INSTALL_DIR) $(1)/usr/lib/accel-ppp

	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/lib/accel-ppp/libpppoe.so $(1)/usr/lib/accel-ppp
endef

$(eval $(call BuildPackage,accel-ppp))
$(eval $(call BuildPackage,accel-ppp-l2tp))
$(eval $(call BuildPackage,accel-ppp-sstp))
$(eval $(call BuildPackage,accel-ppp-pptp))
$(eval $(call BuildPackage,accel-ppp-pppoe))

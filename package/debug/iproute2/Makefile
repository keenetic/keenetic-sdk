#
# Copyright (C) 2006-2015 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=iproute2
PKG_VERSION:=5.6.0
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.xz
PKG_SOURCE_URL:=@KERNEL/linux/utils/net/iproute2
PKG_HASH:=1b5b0e25ce6e23da7526ea1da044e814ad85ba761b10dd29c2b027c056b04692
PKG_BUILD_PARALLEL:=1
PKG_BUILD_DEPENDS:=iptables
PKG_LICENSE:=GPL-2.0
PKG_CPE_ID:=cpe:/a:iproute2_project:iproute2

include $(INCLUDE_DIR)/kernel.mk
include $(INCLUDE_DIR)/package.mk

define Package/iproute2/Default
  SECTION:=debug
  CATEGORY:=Debug suite
  URL:=http://www.linuxfoundation.org/collaborate/workgroups/networking/iproute2
  SUBMENU:=Routing and Redirection
  MAINTAINER:=Russell Senior <russell@personaltelco.net>
endef

define Package/ip-tiny
$(call Package/iproute2/Default)
 TITLE:=Routing control utility (Minimal)
 DEPENDS:=+libnl-tiny +(PACKAGE_devlink||PACKAGE_rdma):libmnl
endef

define Package/ip
$(call Package/iproute2/Default)
 TITLE:=Routing control utility (Full)
 DEPENDS:=+libnl-tiny +(PACKAGE_devlink||PACKAGE_rdma):libmnl
endef

define Package/tc
$(call Package/iproute2/Default)
  TITLE:=Traffic control utility
  DEPENDS:=+kmod-sched-core +libxtables +(PACKAGE_devlink||PACKAGE_rdma):libmnl
endef

define Package/genl
$(call Package/iproute2/Default)
  TITLE:=General netlink utility frontend
  DEPENDS:=+libnl-tiny +(PACKAGE_devlink||PACKAGE_rdma):libmnl
endef

define Package/ip-bridge
$(call Package/iproute2/Default)
  TITLE:=Bridge configuration utility from iproute2
  DEPENDS:=+libnl-tiny +(PACKAGE_devlink||PACKAGE_rdma):libmnl
endef

define Package/ss
$(call Package/iproute2/Default)
  TITLE:=Socket statistics utility
  DEPENDS:=+libnl-tiny +(PACKAGE_devlink||PACKAGE_rdma):libmnl +kmod-netlink-diag
endef

define Package/nstat
$(call Package/iproute2/Default)
  TITLE:=Network statistics utility
  DEPENDS:=+libnl-tiny +(PACKAGE_devlink||PACKAGE_rdma):libmnl
endef

define Package/devlink
$(call Package/iproute2/Default)
  TITLE:=Network devlink utility
  DEPENDS:=+libmnl
endef

define Package/rdma
$(call Package/iproute2/Default)
  TITLE:=Network rdma utility
  DEPENDS:=+libmnl
endef

define Build/Configure
	echo "static const char SNAPSHOT[] = \"$(PKG_VERSION)-$(PKG_RELEASE)-openwrt\";" \
		> $(PKG_BUILD_DIR)/include/SNAPSHOT.h
endef

TARGET_CFLAGS += -ffunction-sections -fdata-sections -flto
TARGET_LDFLAGS += -Wl,--gc-sections
TARGET_CPPFLAGS += -I$(STAGING_DIR)/usr/include/libnl-tiny

MAKE_FLAGS += \
	KERNEL_INCLUDE="$(LINUX_DIR)/user_headers/include" \
	SHARED_LIBS=y \
	IP_CONFIG_TINY=n \
	HAVE_ELF=n \
	HAVE_MNL=n \
	HAVE_CAP=n \
	IPT_LIB_DIR=/usr/lib/iptables \
	XT_LIB_DIR=/usr/lib/iptables \
	FPIC="$(FPIC)"

define Build/Compile
	+$(MAKE_VARS) $(MAKE) $(PKG_JOBS) -C $(PKG_BUILD_DIR) $(MAKE_FLAGS)
endef

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include
	$(CP) $(PKG_BUILD_DIR)/include/{libgenl,libnetlink}.h $(1)/usr/include/
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_BUILD_DIR)/lib/libnetlink.a $(1)/usr/lib/
endef

define Package/ip-tiny/install
	$(INSTALL_DIR) $(1)/usr/libexec
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/ip/ip $(1)/usr/libexec/ip-tiny
endef

define Package/ip/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/ip/ip $(1)/usr/sbin/ip
endef

define Package/tc/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/tc/tc $(1)/usr/sbin/
	$(INSTALL_DIR) $(1)/usr/lib/tc
	$(CP) $(PKG_BUILD_DIR)/tc/*.so $(1)/usr/lib/tc
endef

define Package/genl/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/genl/genl $(1)/usr/sbin/
endef

define Package/ip-bridge/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/bridge/bridge $(1)/usr/sbin/
endef

define Package/ss/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/misc/ss $(1)/usr/sbin/
endef

define Package/nstat/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/misc/nstat $(1)/usr/sbin/
endef

define Package/devlink/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/devlink/devlink $(1)/usr/sbin/
endef

define Package/rdma/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/rdma/rdma $(1)/usr/sbin/
endef

#$(eval $(call BuildPackage,ip-tiny))
$(eval $(call BuildPackage,ip))
$(eval $(call BuildPackage,tc))
#$(eval $(call BuildPackage,genl))
#$(eval $(call BuildPackage,ip-bridge))
#$(eval $(call BuildPackage,ss))
#$(eval $(call BuildPackage,nstat))
#$(eval $(call BuildPackage,devlink))
#$(eval $(call BuildPackage,rdma))

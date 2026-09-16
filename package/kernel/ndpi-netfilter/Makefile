#
# Copyright (C) 2010 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=ndpi-netfilter
PKG_VERSION:=3.2-0

PKG_SOURCE_URL:=https://github.com/ndmsystems/nDPI
PKG_SOURCE_VERSION:=$(PKG_VERSION)
PKG_SOURCE_PROTO:=git

include $(INCLUDE_DIR)/package.mk

define Package/iptables-mod-ndpi
  SUBMENU:=Firewall
  SECTION:=net
  CATEGORY:=Network
  TITLE:=ndpi successor of OpenDPI
  URL:=http://www.ntop.org/products/ndpi/
  DEPENDS:=+iptables +iptables-mod-conntrack-extra +kmod-ipt-ndpi
endef

define Package/iptables-mod-ndpi/description
  nDPI is a ntop-maintained superset of the popular OpenDPI library
endef

PKG_FIXUP:=autoreconf

CONFIGURE_ARGS += --with-pic

define Build/Configure
	(cd $(PKG_BUILD_DIR); AUTOGEN_SUBDIR_MODE=1 ./autogen.sh );
	$(call Build/Configure/Default)
endef

MAKE_PATH:=ndpi-netfilter

MAKE_FLAGS += \
	KERNEL_DIR="$(LINUX_DIR)" \
	MODULES_DIR="$(TARGET_MODULES_DIR)" \
	NDPI_PATH=$(PKG_BUILD_DIR)/ndpi-netfilter

define Build/Compile
	(cd $(PKG_BUILD_DIR)/src/lib &&\
		gcc -g -O2 -fPIC -DPIC -DNDPI_LIB_COMPILATION -I../../src/include/ -I../../src/lib/third_party/include/ ndpi_network_list_compile.c -o ndpi_network_list_compile &&\
		./ndpi_network_list_compile -o ndpi_network_list.c.inc ndpi_network_list_std.yaml ndpi_network_list_tor.yaml)
	make $(MAKE_FLAGS) -C $(PKG_BUILD_DIR)/ndpi-netfilter
endef

define Package/iptables-mod-ndpi/install
	$(INSTALL_DIR) $(1)/usr/lib/iptables
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/ndpi-netfilter/ipt/libxt_ndpi.so $(1)/usr/lib/iptables
endef

define KernelPackage/ipt-ndpi
  SUBMENU:=Netfilter Extensions
  TITLE:= nDPI net netfilter module
  DEPENDS:=+kmod-nf-conntrack +kmod-nf-conntrack-netlink +kmod-ipt-compat-xtables +kmod-ipt-conntrack-label
  FILES:= \
	$(PKG_BUILD_DIR)/ndpi-netfilter/src/xt_ndpi.ko
endef

$(eval $(call BuildPackage,iptables-mod-ndpi))
$(eval $(call KernelPackage,ipt-ndpi))

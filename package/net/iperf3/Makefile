#
# Copyright (C) 2023 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=iperf3
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define Package/iperf3
  CATEGORY:=Network
  TITLE:=Internet Protocol bandwidth measuring tool
  DEPENDS:=+libc +SSP_SUPPORT:libssp
  DISABLE_RSTRIP:=y
endef

define Package/iperf3/install
	if [ -d ./files-iperf3 ]; then \
		$(CP) ./files-iperf3/* $(1); \
	fi
endef

$(eval $(call BuildPackage,iperf3))

define Package/iperf3-ssl
  CATEGORY:=Network
  TITLE:=Internet Protocol bandwidth measuring tool with iperf_auth support
  DEPENDS:=+libc +SSP_SUPPORT:libssp +libopenssl
  DISABLE_RSTRIP:=y
endef

define Package/iperf3-ssl/install
	if [ -d ./files-iperf3-ssl ]; then \
		$(CP) ./files-iperf3-ssl/* $(1); \
	fi
endef

$(eval $(call BuildPackage,iperf3-ssl))

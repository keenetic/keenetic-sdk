#
# Copyright (C) 2022 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=ndnproxy
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define Package/ndnproxy
  CATEGORY:=Network
  TITLE:=Lightweight DNS proxy
  DEPENDS:=+libc +SSP_SUPPORT:libssp +librt +libndm +NDNPROXY_BACKTRACE:libfatalsig
  DISABLE_RSTRIP:=y
endef

define Package/ndnproxy/config
if PACKAGE_ndnproxy

config NDNPROXY_BACKTRACE
	bool "Log a backtrace on a server crash"
	default n

endif
endef

define Package/ndnproxy/install
	if [ -d ./files-ndnproxy ]; then \
		$(CP) ./files-ndnproxy/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndnproxy))

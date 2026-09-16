#
# Copyright (C) 2026 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=cwmpclient
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define Package/cwmpclient
  CATEGORY:=Network
  TITLE:=CPE WAN Management Protocol client
  DEPENDS:=+libc +SSP_SUPPORT:libssp +libndm +libevent +CWMP_BACKTRACE:libfatalsig +libopenssl
  DISABLE_RSTRIP:=y
endef

define Package/cwmpclient/config
	source "package/private/cwmpclient/cwmpclient.in"
endef

define Package/cwmpclient/install
	if [ -d ./files-cwmpclient ]; then \
		$(CP) ./files-cwmpclient/* $(1); \
	fi
endef

$(eval $(call BuildPackage,cwmpclient))

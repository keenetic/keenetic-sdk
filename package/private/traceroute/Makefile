#
# Copyright (C) 2022 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=traceroute
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define Package/traceroute
  CATEGORY:=Network
  TITLE:=Traceroute utility for NDM
  DEPENDS:=+libc +SSP_SUPPORT:libssp +librt
  DISABLE_RSTRIP:=y
endef

define Package/traceroute/install
	if [ -d ./files-traceroute ]; then \
		$(CP) ./files-traceroute/* $(1); \
	fi
endef

$(eval $(call BuildPackage,traceroute))

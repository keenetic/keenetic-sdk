#
# Copyright (C) 2023 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=udpxy
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define Package/udpxy
  CATEGORY:=Network
  TITLE:=Convert UDP IPTV streams into HTTP stream
  DEPENDS:=+libc +SSP_SUPPORT:libssp
  DISABLE_RSTRIP:=y
endef

define Package/udpxy/install
	if [ -d ./files-udpxy ]; then \
		$(CP) ./files-udpxy/* $(1); \
	fi
endef

$(eval $(call BuildPackage,udpxy))

#
# Copyright (C) 2022 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=transmission-web-control
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define Package/transmission-web-control-full
  CATEGORY:=Network
  TITLE:=Transmission Web Control (full)
  DEPENDS:=+libc +SSP_SUPPORT:libssp +transmission-daemon
  DISABLE_RSTRIP:=y
endef

define Package/transmission-web-control-full/install
	if [ -d ./files-transmission-web-control-full ]; then \
		$(CP) ./files-transmission-web-control-full/* $(1); \
	fi
endef

$(eval $(call BuildPackage,transmission-web-control-full))

define Package/transmission-web-control-tiny
  CATEGORY:=Network
  TITLE:=Transmission Web Control (tiny)
  DEPENDS:=+libc +SSP_SUPPORT:libssp +transmission-daemon
  DISABLE_RSTRIP:=y
endef

define Package/transmission-web-control-tiny/install
	if [ -d ./files-transmission-web-control-tiny ]; then \
		$(CP) ./files-transmission-web-control-tiny/* $(1); \
	fi
endef

$(eval $(call BuildPackage,transmission-web-control-tiny))

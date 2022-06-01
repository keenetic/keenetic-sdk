#
# Copyright (C) 2022 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=ppp
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define Package/ppp
  CATEGORY:=Network
  TITLE:=PPP daemon
  DEPENDS:=+libc +SSP_SUPPORT:libssp +kmod-ppp +libopenssl
  DISABLE_RSTRIP:=y
endef

define Package/ppp/install
	if [ -d ./files-ppp ]; then \
		$(CP) ./files-ppp/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ppp))

define Package/ppp-mod-pppoe
  CATEGORY:=Network
  TITLE:=PPPoE plugin
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ppp +kmod-pppoe +librt
  DISABLE_RSTRIP:=y
endef

define Package/ppp-mod-pppoe/install
	if [ -d ./files-ppp-mod-pppoe ]; then \
		$(CP) ./files-ppp-mod-pppoe/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ppp-mod-pppoe))

define Package/ppp-mod-pppol2tp
  CATEGORY:=Network
  TITLE:=L2TP plugin
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ppp +kmod-pppol2tp-kernel
  DISABLE_RSTRIP:=y
endef

define Package/ppp-mod-pppol2tp/install
	if [ -d ./files-ppp-mod-pppol2tp ]; then \
		$(CP) ./files-ppp-mod-pppol2tp/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ppp-mod-pppol2tp))

define Package/ppp-mod-pptp
  CATEGORY:=Network
  TITLE:=PPTP plugin
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ppp +kmod-pptp +kmod-mppe
  DISABLE_RSTRIP:=y
endef

define Package/ppp-mod-pptp/install
	if [ -d ./files-ppp-mod-pptp ]; then \
		$(CP) ./files-ppp-mod-pptp/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ppp-mod-pptp))

define Package/ppp-mod-radius
  CATEGORY:=Network
  TITLE:=RADIUS plugin
  DEPENDS:=+libc +SSP_SUPPORT:libssp ppp
  DISABLE_RSTRIP:=y
endef

define Package/ppp-mod-radius/install
	if [ -d ./files-ppp-mod-radius ]; then \
		$(CP) ./files-ppp-mod-radius/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ppp-mod-radius))

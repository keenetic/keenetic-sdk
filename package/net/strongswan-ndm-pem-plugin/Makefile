#
# Copyright (C) 2022 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=strongswan-ndm-pem-plugin
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define Package/strongswan-ndm-pem-plugin
  CATEGORY:=Network
  TITLE:=Strongswan NDM PEM loader
  DEPENDS:=+libc +SSP_SUPPORT:libssp +strongswan +libndm
  DISABLE_RSTRIP:=y
endef

define Package/strongswan-ndm-pem-plugin/install
	if [ -d ./files-strongswan-ndm-pem-plugin ]; then \
		$(CP) ./files-strongswan-ndm-pem-plugin/* $(1); \
	fi
endef

$(eval $(call BuildPackage,strongswan-ndm-pem-plugin))

#
# Copyright (C) 2022 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=pure-ftpd
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define Package/pureftpd
  CATEGORY:=Network
  TITLE:=FTP server
  DEPENDS:=+libc +SSP_SUPPORT:libssp +libndm +libndmacl_stub
  DISABLE_RSTRIP:=y
endef

define Package/pureftpd/install
	if [ -d ./files-pureftpd ]; then \
		$(CP) ./files-pureftpd/* $(1); \
	fi
endef

$(eval $(call BuildPackage,pureftpd))

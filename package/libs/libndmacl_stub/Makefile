#
# Copyright (C) 2023 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=libndmacl_stub
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define Package/libndmacl_stub
  CATEGORY:=Libraries
  TITLE:=NDM ACL stub library
  DEPENDS:=+libc +SSP_SUPPORT:libssp +libpthread +libndmacl_headers
  DISABLE_RSTRIP:=y
endef

define Package/libndmacl_stub/install
	if [ -d ./files-libndmacl_stub ]; then \
		$(CP) ./files-libndmacl_stub/* $(1); \
	fi
endef

$(eval $(call BuildPackage,libndmacl_stub))

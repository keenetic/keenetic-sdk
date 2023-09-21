#
# Copyright (C) 2023 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=libndmacl
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define Package/libndmacl
  CATEGORY:=Libraries
  TITLE:=NDM ACL library
  DEPENDS:=+libc +SSP_SUPPORT:libssp +libpthread
  DISABLE_RSTRIP:=y
endef

define Package/libndmacl/install
	if [ -d ./files-libndmacl ]; then \
		$(CP) ./files-libndmacl/* $(1); \
	fi
endef

$(eval $(call BuildPackage,libndmacl))

define Package/libndmacl_headers
  CATEGORY:=Libraries
  TITLE:=NDM ACL library headers
  DEPENDS:=+libc +SSP_SUPPORT:libssp
  DISABLE_RSTRIP:=y
endef

define Package/libndmacl_headers/install
	if [ -d ./files-libndmacl_headers ]; then \
		$(CP) ./files-libndmacl_headers/* $(1); \
	fi
endef

$(eval $(call BuildPackage,libndmacl_headers))

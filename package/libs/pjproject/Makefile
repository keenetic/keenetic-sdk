#
# Copyright (C) 2023 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=pjproject
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define Package/pjproject
  CATEGORY:=Libraries
  TITLE:=PJSIP
  DEPENDS:=+libc +SSP_SUPPORT:libssp +libopenssl +PJPROJECT_MIMALLOC:mimalloc +PJPROJECT_MIMALLOC:libatomic
  DISABLE_RSTRIP:=y
endef

define Package/pjproject/config
	config PJPROJECT_MIMALLOC
		bool "Use mimalloc for in heap memory allocation"
		depends on PACKAGE_pjproject
		default y
endef

define Package/pjproject/install
	if [ -d ./files-pjproject ]; then \
		$(CP) ./files-pjproject/* $(1); \
	fi
endef

$(eval $(call BuildPackage,pjproject))

define Package/pjproject-utils
  CATEGORY:=Utilities
  TITLE:=PJSIP
  DEPENDS:=+libc +SSP_SUPPORT:libssp +pjproject
  DISABLE_RSTRIP:=y
endef

define Package/pjproject-utils/install
	if [ -d ./files-pjproject-utils ]; then \
		$(CP) ./files-pjproject-utils/* $(1); \
	fi
endef

$(eval $(call BuildPackage,pjproject-utils))

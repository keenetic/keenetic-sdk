#
# Copyright (C) 2023 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=npkg
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define Package/npkg
  CATEGORY:=Utilities
  TITLE:=Ipkg package manager
  DEPENDS:=+libc +SSP_SUPPORT:libssp +libndm +zlib
  DISABLE_RSTRIP:=y
endef

define Package/npkg/install
	if [ -d ./files-npkg ]; then \
		$(CP) ./files-npkg/* $(1); \
	fi
endef

$(eval $(call BuildPackage,npkg))

#
# Copyright (C) 2023 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=libndmfw
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define Package/libndmfw
  CATEGORY:=Libraries
  TITLE:=NDM firmware library
  DEPENDS:=+libc +SSP_SUPPORT:libssp +libndm +libopenssl
  DISABLE_RSTRIP:=y
endef

define Package/libndmfw/install
	if [ -d ./files-libndmfw ]; then \
		$(CP) ./files-libndmfw/* $(1); \
	fi
endef

$(eval $(call BuildPackage,libndmfw))

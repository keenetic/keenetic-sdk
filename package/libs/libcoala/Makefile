#
# Copyright (C) 2022 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=libcoala
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define Package/libcoala
  CATEGORY:=Libraries
  TITLE:=Cloud agent CoAP library
  DEPENDS:=+libc +SSP_SUPPORT:libssp +libndm +libopenssl
  DISABLE_RSTRIP:=y
endef

define Package/libcoala/install
	if [ -d ./files-libcoala ]; then \
		$(CP) ./files-libcoala/* $(1); \
	fi
endef

$(eval $(call BuildPackage,libcoala))

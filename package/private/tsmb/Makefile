#
# Copyright (C) 2023 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=tsmb
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define Package/tsmb
  CATEGORY:=Network
  TITLE:=Tuxera SMB server
  DEPENDS:=+libc +SSP_SUPPORT:libssp +libpthread +libopenssl +libndm +libndmacl_stub
  DISABLE_RSTRIP:=y
endef

define Package/tsmb/install
	if [ -d ./files-tsmb ]; then \
		$(CP) ./files-tsmb/* $(1); \
	fi
endef

$(eval $(call BuildPackage,tsmb))

#
# Copyright (C) 2022 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=nprint
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define Package/nprint
  CATEGORY:=Base system
  TITLE:=Tiny non-spooling printer server
  DEPENDS:=+libc +SSP_SUPPORT:libssp +libndm
  DISABLE_RSTRIP:=y
endef

define Package/nprint/install
	if [ -d ./files-nprint ]; then \
		$(CP) ./files-nprint/* $(1); \
	fi
endef

$(eval $(call BuildPackage,nprint))

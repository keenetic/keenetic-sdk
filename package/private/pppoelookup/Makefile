#
# Copyright (C) 2022 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=pppoelookup
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define Package/pppoelookup
  CATEGORY:=Network
  TITLE:=PPPoE lookup utility for NDM
  DEPENDS:=+libc +SSP_SUPPORT:libssp +libndm
  DISABLE_RSTRIP:=y
endef

define Package/pppoelookup/install
	if [ -d ./files-pppoelookup ]; then \
		$(CP) ./files-pppoelookup/* $(1); \
	fi
endef

$(eval $(call BuildPackage,pppoelookup))

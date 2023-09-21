#
# Copyright (C) 2023 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=kabinet
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define Package/kabinet
  CATEGORY:=Network
  TITLE:=Kabinet authenticator
  DEPENDS:=+libc +SSP_SUPPORT:libssp +libndm
  DISABLE_RSTRIP:=y
endef

define Package/kabinet/install
	if [ -d ./files-kabinet ]; then \
		$(CP) ./files-kabinet/* $(1); \
	fi
endef

$(eval $(call BuildPackage,kabinet))

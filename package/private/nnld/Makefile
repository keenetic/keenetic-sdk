#
# Copyright (C) 2023 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=nnld
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define Package/nnld
  CATEGORY:=Base system
  TITLE:=NDM netlink daemon
  DEPENDS:=+libc +SSP_SUPPORT:libssp +libndm
  DISABLE_RSTRIP:=y
endef

define Package/nnld/install
	if [ -d ./files-nnld ]; then \
		$(CP) ./files-nnld/* $(1); \
	fi
endef

$(eval $(call BuildPackage,nnld))

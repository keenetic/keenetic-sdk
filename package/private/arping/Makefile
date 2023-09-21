#
# Copyright (C) 2023 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=arping
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define Package/arping
  CATEGORY:=Network
  TITLE:=ARP ping utility for NDM
  DEPENDS:=+libc +SSP_SUPPORT:libssp +libndm
  DISABLE_RSTRIP:=y
endef

define Package/arping/install
	if [ -d ./files-arping ]; then \
		$(CP) ./files-arping/* $(1); \
	fi
endef

$(eval $(call BuildPackage,arping))

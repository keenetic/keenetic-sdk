#
# Copyright (C) 2022 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=init
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define Package/init
  CATEGORY:=Base system
  TITLE:=Lightweight init process for NDM
  DEPENDS:=+libc +SSP_SUPPORT:libssp
  DISABLE_RSTRIP:=y
endef

define Package/init/install
	if [ -d ./files-init ]; then \
		$(CP) ./files-init/* $(1); \
	fi
endef

$(eval $(call BuildPackage,init))

#
# Copyright (C) 2023 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=nsh
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define Package/nsh
  CATEGORY:=Base system
  TITLE:=NDM Shell wrapper
  DEPENDS:=+libc +SSP_SUPPORT:libssp
  DISABLE_RSTRIP:=y
endef

define Package/nsh/install
	if [ -d ./files-nsh ]; then \
		$(CP) ./files-nsh/* $(1); \
	fi
endef

$(eval $(call BuildPackage,nsh))

define Package/nsh-static
  CATEGORY:=Base system
  TITLE:=NDM Shell wrapper
  DEPENDS:=+libc +SSP_SUPPORT:libssp
  DISABLE_RSTRIP:=y
endef

define Package/nsh-static/install
	if [ -d ./files-nsh-static ]; then \
		$(CP) ./files-nsh-static/* $(1); \
	fi
endef

$(eval $(call BuildPackage,nsh-static))

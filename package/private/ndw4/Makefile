#
# Copyright (C) 2023 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=ndw4
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define Package/ndw4
  CATEGORY:=NDM
  TITLE:=Next-generation web interface (beta)
  DEPENDS:=+libc +SSP_SUPPORT:libssp +fonts-roboto
  DISABLE_RSTRIP:=y
endef

define Package/ndw4/install
	if [ -d ./files-ndw4 ]; then \
		$(CP) ./files-ndw4/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndw4))

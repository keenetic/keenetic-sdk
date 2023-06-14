#
# Copyright (C) 2022 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=bluedroid
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define Package/bluedroid
  CATEGORY:=Libraries
  TITLE:=MTK bluedroid library
  DEPENDS:=+libc +SSP_SUPPORT:libssp +zlib +libstdcpp +librt +libpthread
  DISABLE_RSTRIP:=y
endef

define Package/bluedroid/config
	source "package/libs/bluedroid/Config.in"
endef

define Package/bluedroid/install
	if [ -d ./files-bluedroid ]; then \
		$(CP) ./files-bluedroid/* $(1); \
	fi
endef

$(eval $(call BuildPackage,bluedroid))

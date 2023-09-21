#
# Copyright (C) 2023 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=fxs
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define Package/fxs
  CATEGORY:=Multimedia
  TITLE:=FXS dongle API
  DEPENDS:=+libc +SSP_SUPPORT:libssp
  DISABLE_RSTRIP:=y
endef

define Package/fxs/install
	if [ -d ./files-fxs ]; then \
		$(CP) ./files-fxs/* $(1); \
	fi
endef

$(eval $(call BuildPackage,fxs))

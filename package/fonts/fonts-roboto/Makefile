#
# Copyright (C) 2023 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=fonts-roboto
PKG_VERSION:=1.0
PKG_LICENSE:=Apache-2.0

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  TITLE:=Google's signature family of fonts
  SECTION:=fonts
  CATEGORY:=Fonts
  URL:=https://fonts.google.com/specimen/Roboto
endef

define Build/Compile
	true
endef

define Build/Configure
	true
endef

$(eval $(call BuildPackage,$(PKG_NAME)))

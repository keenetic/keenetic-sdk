#
# Copyright (C) 2023 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=crowdin-editor
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define Package/crowdin-editor
  CATEGORY:=NDM
  TITLE:=Internal CrowdIn editor component
  DEPENDS:=+libc +SSP_SUPPORT:libssp +angular-ndw +angular-ndw-zz-locale
  DISABLE_RSTRIP:=y
endef

define Package/crowdin-editor/install
	if [ -d ./files-crowdin-editor ]; then \
		$(CP) ./files-crowdin-editor/* $(1); \
	fi
endef

$(eval $(call BuildPackage,crowdin-editor))

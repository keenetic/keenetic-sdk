#
# Copyright (C) 2026 Keenetic Limited
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
  SUBMENU:=Web interface
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

define Package/ndw4-da-locale
  SUBMENU:=Web interface
  CATEGORY:=NDM
  TITLE:=Next-generation web interface (beta) (DA locale)
  DEPENDS:=+libc +SSP_SUPPORT:libssp ndw4
  DISABLE_RSTRIP:=y
endef

define Package/ndw4-da-locale/install
	if [ -d ./files-ndw4-da-locale ]; then \
		$(CP) ./files-ndw4-da-locale/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndw4-da-locale))

define Package/ndw4-de-locale
  SUBMENU:=Web interface
  CATEGORY:=NDM
  TITLE:=Next-generation web interface (beta) (DE locale)
  DEPENDS:=+libc +SSP_SUPPORT:libssp ndw4
  DISABLE_RSTRIP:=y
endef

define Package/ndw4-de-locale/install
	if [ -d ./files-ndw4-de-locale ]; then \
		$(CP) ./files-ndw4-de-locale/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndw4-de-locale))

define Package/ndw4-en-locale
  SUBMENU:=Web interface
  CATEGORY:=NDM
  TITLE:=Next-generation web interface (beta) (EN locale)
  DEPENDS:=+libc +SSP_SUPPORT:libssp ndw4
  DISABLE_RSTRIP:=y
endef

define Package/ndw4-en-locale/install
	if [ -d ./files-ndw4-en-locale ]; then \
		$(CP) ./files-ndw4-en-locale/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndw4-en-locale))

define Package/ndw4-es-locale
  SUBMENU:=Web interface
  CATEGORY:=NDM
  TITLE:=Next-generation web interface (beta) (ES locale)
  DEPENDS:=+libc +SSP_SUPPORT:libssp ndw4
  DISABLE_RSTRIP:=y
endef

define Package/ndw4-es-locale/install
	if [ -d ./files-ndw4-es-locale ]; then \
		$(CP) ./files-ndw4-es-locale/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndw4-es-locale))

define Package/ndw4-fi-locale
  SUBMENU:=Web interface
  CATEGORY:=NDM
  TITLE:=Next-generation web interface (beta) (FI locale)
  DEPENDS:=+libc +SSP_SUPPORT:libssp ndw4
  DISABLE_RSTRIP:=y
endef

define Package/ndw4-fi-locale/install
	if [ -d ./files-ndw4-fi-locale ]; then \
		$(CP) ./files-ndw4-fi-locale/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndw4-fi-locale))

define Package/ndw4-fr-locale
  SUBMENU:=Web interface
  CATEGORY:=NDM
  TITLE:=Next-generation web interface (beta) (FR locale)
  DEPENDS:=+libc +SSP_SUPPORT:libssp ndw4
  DISABLE_RSTRIP:=y
endef

define Package/ndw4-fr-locale/install
	if [ -d ./files-ndw4-fr-locale ]; then \
		$(CP) ./files-ndw4-fr-locale/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndw4-fr-locale))

define Package/ndw4-it-locale
  SUBMENU:=Web interface
  CATEGORY:=NDM
  TITLE:=Next-generation web interface (beta) (IT locale)
  DEPENDS:=+libc +SSP_SUPPORT:libssp ndw4
  DISABLE_RSTRIP:=y
endef

define Package/ndw4-it-locale/install
	if [ -d ./files-ndw4-it-locale ]; then \
		$(CP) ./files-ndw4-it-locale/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndw4-it-locale))

define Package/ndw4-pl-locale
  SUBMENU:=Web interface
  CATEGORY:=NDM
  TITLE:=Next-generation web interface (beta) (PL locale)
  DEPENDS:=+libc +SSP_SUPPORT:libssp ndw4
  DISABLE_RSTRIP:=y
endef

define Package/ndw4-pl-locale/install
	if [ -d ./files-ndw4-pl-locale ]; then \
		$(CP) ./files-ndw4-pl-locale/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndw4-pl-locale))

define Package/ndw4-pt-locale
  SUBMENU:=Web interface
  CATEGORY:=NDM
  TITLE:=Next-generation web interface (beta) (PT locale)
  DEPENDS:=+libc +SSP_SUPPORT:libssp ndw4
  DISABLE_RSTRIP:=y
endef

define Package/ndw4-pt-locale/install
	if [ -d ./files-ndw4-pt-locale ]; then \
		$(CP) ./files-ndw4-pt-locale/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndw4-pt-locale))

define Package/ndw4-ru-locale
  SUBMENU:=Web interface
  CATEGORY:=NDM
  TITLE:=Next-generation web interface (beta) (RU locale)
  DEPENDS:=+libc +SSP_SUPPORT:libssp ndw4
  DISABLE_RSTRIP:=y
endef

define Package/ndw4-ru-locale/install
	if [ -d ./files-ndw4-ru-locale ]; then \
		$(CP) ./files-ndw4-ru-locale/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndw4-ru-locale))

define Package/ndw4-sv-locale
  SUBMENU:=Web interface
  CATEGORY:=NDM
  TITLE:=Next-generation web interface (beta) (SV locale)
  DEPENDS:=+libc +SSP_SUPPORT:libssp ndw4
  DISABLE_RSTRIP:=y
endef

define Package/ndw4-sv-locale/install
	if [ -d ./files-ndw4-sv-locale ]; then \
		$(CP) ./files-ndw4-sv-locale/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndw4-sv-locale))

define Package/ndw4-tr-locale
  SUBMENU:=Web interface
  CATEGORY:=NDM
  TITLE:=Next-generation web interface (beta) (TR locale)
  DEPENDS:=+libc +SSP_SUPPORT:libssp ndw4
  DISABLE_RSTRIP:=y
endef

define Package/ndw4-tr-locale/install
	if [ -d ./files-ndw4-tr-locale ]; then \
		$(CP) ./files-ndw4-tr-locale/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndw4-tr-locale))

define Package/ndw4-uk-locale
  SUBMENU:=Web interface
  CATEGORY:=NDM
  TITLE:=Next-generation web interface (beta) (UK locale)
  DEPENDS:=+libc +SSP_SUPPORT:libssp ndw4
  DISABLE_RSTRIP:=y
endef

define Package/ndw4-uk-locale/install
	if [ -d ./files-ndw4-uk-locale ]; then \
		$(CP) ./files-ndw4-uk-locale/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndw4-uk-locale))

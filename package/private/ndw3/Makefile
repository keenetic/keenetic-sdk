#
# Copyright (C) 2026 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=ndw3
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define Package/ndw3
  SUBMENU:=Web interface
  CATEGORY:=NDM
  TITLE:=Web interface wizard
  DEPENDS:=+libc +SSP_SUPPORT:libssp @!NO_WIZARD +fonts-roboto
  DISABLE_RSTRIP:=y
endef

define Package/ndw3/install
	if [ -d ./files-ndw3 ]; then \
		$(CP) ./files-ndw3/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndw3))

define Package/ndw3-da-locale
  SUBMENU:=Web interface
  CATEGORY:=NDM
  TITLE:=Web interface wizard (DA locale)
  DEPENDS:=+libc +SSP_SUPPORT:libssp @!NO_WIZARD
  DISABLE_RSTRIP:=y
endef

define Package/ndw3-da-locale/install
	if [ -d ./files-ndw3-da-locale ]; then \
		$(CP) ./files-ndw3-da-locale/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndw3-da-locale))

define Package/ndw3-de-locale
  SUBMENU:=Web interface
  CATEGORY:=NDM
  TITLE:=Web interface wizard (DE locale)
  DEPENDS:=+libc +SSP_SUPPORT:libssp @!NO_WIZARD
  DISABLE_RSTRIP:=y
endef

define Package/ndw3-de-locale/install
	if [ -d ./files-ndw3-de-locale ]; then \
		$(CP) ./files-ndw3-de-locale/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndw3-de-locale))

define Package/ndw3-en-locale
  SUBMENU:=Web interface
  CATEGORY:=NDM
  TITLE:=Web interface wizard (EN locale)
  DEPENDS:=+libc +SSP_SUPPORT:libssp @!NO_WIZARD
  DISABLE_RSTRIP:=y
endef

define Package/ndw3-en-locale/install
	if [ -d ./files-ndw3-en-locale ]; then \
		$(CP) ./files-ndw3-en-locale/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndw3-en-locale))

define Package/ndw3-es-locale
  SUBMENU:=Web interface
  CATEGORY:=NDM
  TITLE:=Web interface wizard (ES locale)
  DEPENDS:=+libc +SSP_SUPPORT:libssp @!NO_WIZARD
  DISABLE_RSTRIP:=y
endef

define Package/ndw3-es-locale/install
	if [ -d ./files-ndw3-es-locale ]; then \
		$(CP) ./files-ndw3-es-locale/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndw3-es-locale))

define Package/ndw3-fi-locale
  SUBMENU:=Web interface
  CATEGORY:=NDM
  TITLE:=Web interface wizard (FI locale)
  DEPENDS:=+libc +SSP_SUPPORT:libssp @!NO_WIZARD
  DISABLE_RSTRIP:=y
endef

define Package/ndw3-fi-locale/install
	if [ -d ./files-ndw3-fi-locale ]; then \
		$(CP) ./files-ndw3-fi-locale/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndw3-fi-locale))

define Package/ndw3-fr-locale
  SUBMENU:=Web interface
  CATEGORY:=NDM
  TITLE:=Web interface wizard (FR locale)
  DEPENDS:=+libc +SSP_SUPPORT:libssp @!NO_WIZARD
  DISABLE_RSTRIP:=y
endef

define Package/ndw3-fr-locale/install
	if [ -d ./files-ndw3-fr-locale ]; then \
		$(CP) ./files-ndw3-fr-locale/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndw3-fr-locale))

define Package/ndw3-it-locale
  SUBMENU:=Web interface
  CATEGORY:=NDM
  TITLE:=Web interface wizard (IT locale)
  DEPENDS:=+libc +SSP_SUPPORT:libssp @!NO_WIZARD
  DISABLE_RSTRIP:=y
endef

define Package/ndw3-it-locale/install
	if [ -d ./files-ndw3-it-locale ]; then \
		$(CP) ./files-ndw3-it-locale/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndw3-it-locale))

define Package/ndw3-pl-locale
  SUBMENU:=Web interface
  CATEGORY:=NDM
  TITLE:=Web interface wizard (PL locale)
  DEPENDS:=+libc +SSP_SUPPORT:libssp @!NO_WIZARD
  DISABLE_RSTRIP:=y
endef

define Package/ndw3-pl-locale/install
	if [ -d ./files-ndw3-pl-locale ]; then \
		$(CP) ./files-ndw3-pl-locale/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndw3-pl-locale))

define Package/ndw3-pt-locale
  SUBMENU:=Web interface
  CATEGORY:=NDM
  TITLE:=Web interface wizard (PT locale)
  DEPENDS:=+libc +SSP_SUPPORT:libssp @!NO_WIZARD
  DISABLE_RSTRIP:=y
endef

define Package/ndw3-pt-locale/install
	if [ -d ./files-ndw3-pt-locale ]; then \
		$(CP) ./files-ndw3-pt-locale/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndw3-pt-locale))

define Package/ndw3-ru-locale
  SUBMENU:=Web interface
  CATEGORY:=NDM
  TITLE:=Web interface wizard (RU locale)
  DEPENDS:=+libc +SSP_SUPPORT:libssp @!NO_WIZARD
  DISABLE_RSTRIP:=y
endef

define Package/ndw3-ru-locale/install
	if [ -d ./files-ndw3-ru-locale ]; then \
		$(CP) ./files-ndw3-ru-locale/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndw3-ru-locale))

define Package/ndw3-sv-locale
  SUBMENU:=Web interface
  CATEGORY:=NDM
  TITLE:=Web interface wizard (SV locale)
  DEPENDS:=+libc +SSP_SUPPORT:libssp @!NO_WIZARD
  DISABLE_RSTRIP:=y
endef

define Package/ndw3-sv-locale/install
	if [ -d ./files-ndw3-sv-locale ]; then \
		$(CP) ./files-ndw3-sv-locale/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndw3-sv-locale))

define Package/ndw3-tr-locale
  SUBMENU:=Web interface
  CATEGORY:=NDM
  TITLE:=Web interface wizard (TR locale)
  DEPENDS:=+libc +SSP_SUPPORT:libssp @!NO_WIZARD
  DISABLE_RSTRIP:=y
endef

define Package/ndw3-tr-locale/install
	if [ -d ./files-ndw3-tr-locale ]; then \
		$(CP) ./files-ndw3-tr-locale/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndw3-tr-locale))

define Package/ndw3-uk-locale
  SUBMENU:=Web interface
  CATEGORY:=NDM
  TITLE:=Web interface wizard (UK locale)
  DEPENDS:=+libc +SSP_SUPPORT:libssp @!NO_WIZARD
  DISABLE_RSTRIP:=y
endef

define Package/ndw3-uk-locale/install
	if [ -d ./files-ndw3-uk-locale ]; then \
		$(CP) ./files-ndw3-uk-locale/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndw3-uk-locale))

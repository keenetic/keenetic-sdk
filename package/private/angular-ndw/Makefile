#
# Copyright (C) 2023 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=angular-ndw
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define Package/angular-ndw
  CATEGORY:=NDM
  TITLE:=Angular web interface
  DEPENDS:=+libc +SSP_SUPPORT:libssp +fonts-roboto
  DISABLE_RSTRIP:=y
endef

define Package/angular-ndw/install
	if [ -d ./files-angular-ndw ]; then \
		$(CP) ./files-angular-ndw/* $(1); \
	fi
endef

$(eval $(call BuildPackage,angular-ndw))

define Package/angular-ndw-da-locale
  CATEGORY:=NDM
  TITLE:=Angular web interface (DA locale)
  DEPENDS:=+libc +SSP_SUPPORT:libssp angular-ndw
  DISABLE_RSTRIP:=y
endef

define Package/angular-ndw-da-locale/install
	if [ -d ./files-angular-ndw-da-locale ]; then \
		$(CP) ./files-angular-ndw-da-locale/* $(1); \
	fi
endef

$(eval $(call BuildPackage,angular-ndw-da-locale))

define Package/angular-ndw-de-locale
  CATEGORY:=NDM
  TITLE:=Angular web interface (DE locale)
  DEPENDS:=+libc +SSP_SUPPORT:libssp angular-ndw
  DISABLE_RSTRIP:=y
endef

define Package/angular-ndw-de-locale/install
	if [ -d ./files-angular-ndw-de-locale ]; then \
		$(CP) ./files-angular-ndw-de-locale/* $(1); \
	fi
endef

$(eval $(call BuildPackage,angular-ndw-de-locale))

define Package/angular-ndw-en-locale
  CATEGORY:=NDM
  TITLE:=Angular web interface (EN locale)
  DEPENDS:=+libc +SSP_SUPPORT:libssp angular-ndw
  DISABLE_RSTRIP:=y
endef

define Package/angular-ndw-en-locale/install
	if [ -d ./files-angular-ndw-en-locale ]; then \
		$(CP) ./files-angular-ndw-en-locale/* $(1); \
	fi
endef

$(eval $(call BuildPackage,angular-ndw-en-locale))

define Package/angular-ndw-es-locale
  CATEGORY:=NDM
  TITLE:=Angular web interface (ES locale)
  DEPENDS:=+libc +SSP_SUPPORT:libssp angular-ndw
  DISABLE_RSTRIP:=y
endef

define Package/angular-ndw-es-locale/install
	if [ -d ./files-angular-ndw-es-locale ]; then \
		$(CP) ./files-angular-ndw-es-locale/* $(1); \
	fi
endef

$(eval $(call BuildPackage,angular-ndw-es-locale))

define Package/angular-ndw-fr-locale
  CATEGORY:=NDM
  TITLE:=Angular web interface (FR locale)
  DEPENDS:=+libc +SSP_SUPPORT:libssp angular-ndw
  DISABLE_RSTRIP:=y
endef

define Package/angular-ndw-fr-locale/install
	if [ -d ./files-angular-ndw-fr-locale ]; then \
		$(CP) ./files-angular-ndw-fr-locale/* $(1); \
	fi
endef

$(eval $(call BuildPackage,angular-ndw-fr-locale))

define Package/angular-ndw-it-locale
  CATEGORY:=NDM
  TITLE:=Angular web interface (IT locale)
  DEPENDS:=+libc +SSP_SUPPORT:libssp angular-ndw
  DISABLE_RSTRIP:=y
endef

define Package/angular-ndw-it-locale/install
	if [ -d ./files-angular-ndw-it-locale ]; then \
		$(CP) ./files-angular-ndw-it-locale/* $(1); \
	fi
endef

$(eval $(call BuildPackage,angular-ndw-it-locale))

define Package/angular-ndw-pl-locale
  CATEGORY:=NDM
  TITLE:=Angular web interface (PL locale)
  DEPENDS:=+libc +SSP_SUPPORT:libssp angular-ndw
  DISABLE_RSTRIP:=y
endef

define Package/angular-ndw-pl-locale/install
	if [ -d ./files-angular-ndw-pl-locale ]; then \
		$(CP) ./files-angular-ndw-pl-locale/* $(1); \
	fi
endef

$(eval $(call BuildPackage,angular-ndw-pl-locale))

define Package/angular-ndw-pt-locale
  CATEGORY:=NDM
  TITLE:=Angular web interface (PT locale)
  DEPENDS:=+libc +SSP_SUPPORT:libssp angular-ndw
  DISABLE_RSTRIP:=y
endef

define Package/angular-ndw-pt-locale/install
	if [ -d ./files-angular-ndw-pt-locale ]; then \
		$(CP) ./files-angular-ndw-pt-locale/* $(1); \
	fi
endef

$(eval $(call BuildPackage,angular-ndw-pt-locale))

define Package/angular-ndw-ru-locale
  CATEGORY:=NDM
  TITLE:=Angular web interface (RU locale)
  DEPENDS:=+libc +SSP_SUPPORT:libssp angular-ndw
  DISABLE_RSTRIP:=y
endef

define Package/angular-ndw-ru-locale/install
	if [ -d ./files-angular-ndw-ru-locale ]; then \
		$(CP) ./files-angular-ndw-ru-locale/* $(1); \
	fi
endef

$(eval $(call BuildPackage,angular-ndw-ru-locale))

define Package/angular-ndw-sv-locale
  CATEGORY:=NDM
  TITLE:=Angular web interface (SV locale)
  DEPENDS:=+libc +SSP_SUPPORT:libssp angular-ndw
  DISABLE_RSTRIP:=y
endef

define Package/angular-ndw-sv-locale/install
	if [ -d ./files-angular-ndw-sv-locale ]; then \
		$(CP) ./files-angular-ndw-sv-locale/* $(1); \
	fi
endef

$(eval $(call BuildPackage,angular-ndw-sv-locale))

define Package/angular-ndw-tr-locale
  CATEGORY:=NDM
  TITLE:=Angular web interface (TR locale)
  DEPENDS:=+libc +SSP_SUPPORT:libssp angular-ndw
  DISABLE_RSTRIP:=y
endef

define Package/angular-ndw-tr-locale/install
	if [ -d ./files-angular-ndw-tr-locale ]; then \
		$(CP) ./files-angular-ndw-tr-locale/* $(1); \
	fi
endef

$(eval $(call BuildPackage,angular-ndw-tr-locale))

define Package/angular-ndw-uk-locale
  CATEGORY:=NDM
  TITLE:=Angular web interface (UK locale)
  DEPENDS:=+libc +SSP_SUPPORT:libssp angular-ndw
  DISABLE_RSTRIP:=y
endef

define Package/angular-ndw-uk-locale/install
	if [ -d ./files-angular-ndw-uk-locale ]; then \
		$(CP) ./files-angular-ndw-uk-locale/* $(1); \
	fi
endef

$(eval $(call BuildPackage,angular-ndw-uk-locale))

define Package/angular-ndw-zz-locale
  CATEGORY:=NDM
  TITLE:=Angular web interface (ZZ locale)
  DEPENDS:=+libc +SSP_SUPPORT:libssp angular-ndw
  DISABLE_RSTRIP:=y
endef

define Package/angular-ndw-zz-locale/install
	if [ -d ./files-angular-ndw-zz-locale ]; then \
		$(CP) ./files-angular-ndw-zz-locale/* $(1); \
	fi
endef

$(eval $(call BuildPackage,angular-ndw-zz-locale))

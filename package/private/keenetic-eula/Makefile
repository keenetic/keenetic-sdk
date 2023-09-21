#
# Copyright (C) 2023 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=keenetic-eula
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define Package/keenetic-eula-common
  CATEGORY:=Base system
  TITLE:=Keenetic EULA document files (common)
  DEPENDS:=+libc +SSP_SUPPORT:libssp base-files
  DISABLE_RSTRIP:=y
endef

define Package/keenetic-eula-common/install
	if [ -d ./files-keenetic-eula-common ]; then \
		$(CP) ./files-keenetic-eula-common/* $(1); \
	fi
endef

$(eval $(call BuildPackage,keenetic-eula-common))

define Package/keenetic-eula-da
  CATEGORY:=Base system
  TITLE:=Keenetic EULA document files (DA)
  DEPENDS:=+libc +SSP_SUPPORT:libssp base-files +keenetic-eula-common
  DISABLE_RSTRIP:=y
endef

define Package/keenetic-eula-da/install
	if [ -d ./files-keenetic-eula-da ]; then \
		$(CP) ./files-keenetic-eula-da/* $(1); \
	fi
endef

$(eval $(call BuildPackage,keenetic-eula-da))

define Package/keenetic-eula-de
  CATEGORY:=Base system
  TITLE:=Keenetic EULA document files (DE)
  DEPENDS:=+libc +SSP_SUPPORT:libssp base-files +keenetic-eula-common
  DISABLE_RSTRIP:=y
endef

define Package/keenetic-eula-de/install
	if [ -d ./files-keenetic-eula-de ]; then \
		$(CP) ./files-keenetic-eula-de/* $(1); \
	fi
endef

$(eval $(call BuildPackage,keenetic-eula-de))

define Package/keenetic-eula-en
  CATEGORY:=Base system
  TITLE:=Keenetic EULA document files (EN)
  DEPENDS:=+libc +SSP_SUPPORT:libssp base-files +keenetic-eula-common
  DISABLE_RSTRIP:=y
endef

define Package/keenetic-eula-en/install
	if [ -d ./files-keenetic-eula-en ]; then \
		$(CP) ./files-keenetic-eula-en/* $(1); \
	fi
endef

$(eval $(call BuildPackage,keenetic-eula-en))

define Package/keenetic-eula-es
  CATEGORY:=Base system
  TITLE:=Keenetic EULA document files (ES)
  DEPENDS:=+libc +SSP_SUPPORT:libssp base-files +keenetic-eula-common
  DISABLE_RSTRIP:=y
endef

define Package/keenetic-eula-es/install
	if [ -d ./files-keenetic-eula-es ]; then \
		$(CP) ./files-keenetic-eula-es/* $(1); \
	fi
endef

$(eval $(call BuildPackage,keenetic-eula-es))

define Package/keenetic-eula-fr
  CATEGORY:=Base system
  TITLE:=Keenetic EULA document files (FR)
  DEPENDS:=+libc +SSP_SUPPORT:libssp base-files +keenetic-eula-common
  DISABLE_RSTRIP:=y
endef

define Package/keenetic-eula-fr/install
	if [ -d ./files-keenetic-eula-fr ]; then \
		$(CP) ./files-keenetic-eula-fr/* $(1); \
	fi
endef

$(eval $(call BuildPackage,keenetic-eula-fr))

define Package/keenetic-eula-it
  CATEGORY:=Base system
  TITLE:=Keenetic EULA document files (IT)
  DEPENDS:=+libc +SSP_SUPPORT:libssp base-files +keenetic-eula-common
  DISABLE_RSTRIP:=y
endef

define Package/keenetic-eula-it/install
	if [ -d ./files-keenetic-eula-it ]; then \
		$(CP) ./files-keenetic-eula-it/* $(1); \
	fi
endef

$(eval $(call BuildPackage,keenetic-eula-it))

define Package/keenetic-eula-pl
  CATEGORY:=Base system
  TITLE:=Keenetic EULA document files (PL)
  DEPENDS:=+libc +SSP_SUPPORT:libssp base-files +keenetic-eula-common
  DISABLE_RSTRIP:=y
endef

define Package/keenetic-eula-pl/install
	if [ -d ./files-keenetic-eula-pl ]; then \
		$(CP) ./files-keenetic-eula-pl/* $(1); \
	fi
endef

$(eval $(call BuildPackage,keenetic-eula-pl))

define Package/keenetic-eula-pt
  CATEGORY:=Base system
  TITLE:=Keenetic EULA document files (PT)
  DEPENDS:=+libc +SSP_SUPPORT:libssp base-files +keenetic-eula-common
  DISABLE_RSTRIP:=y
endef

define Package/keenetic-eula-pt/install
	if [ -d ./files-keenetic-eula-pt ]; then \
		$(CP) ./files-keenetic-eula-pt/* $(1); \
	fi
endef

$(eval $(call BuildPackage,keenetic-eula-pt))

define Package/keenetic-eula-ru
  CATEGORY:=Base system
  TITLE:=Keenetic EULA document files (RU)
  DEPENDS:=+libc +SSP_SUPPORT:libssp base-files +keenetic-eula-common
  DISABLE_RSTRIP:=y
endef

define Package/keenetic-eula-ru/install
	if [ -d ./files-keenetic-eula-ru ]; then \
		$(CP) ./files-keenetic-eula-ru/* $(1); \
	fi
endef

$(eval $(call BuildPackage,keenetic-eula-ru))

define Package/keenetic-eula-sv
  CATEGORY:=Base system
  TITLE:=Keenetic EULA document files (SV)
  DEPENDS:=+libc +SSP_SUPPORT:libssp base-files +keenetic-eula-common
  DISABLE_RSTRIP:=y
endef

define Package/keenetic-eula-sv/install
	if [ -d ./files-keenetic-eula-sv ]; then \
		$(CP) ./files-keenetic-eula-sv/* $(1); \
	fi
endef

$(eval $(call BuildPackage,keenetic-eula-sv))

define Package/keenetic-eula-tr
  CATEGORY:=Base system
  TITLE:=Keenetic EULA document files (TR)
  DEPENDS:=+libc +SSP_SUPPORT:libssp base-files +keenetic-eula-common
  DISABLE_RSTRIP:=y
endef

define Package/keenetic-eula-tr/install
	if [ -d ./files-keenetic-eula-tr ]; then \
		$(CP) ./files-keenetic-eula-tr/* $(1); \
	fi
endef

$(eval $(call BuildPackage,keenetic-eula-tr))

define Package/keenetic-eula-uk
  CATEGORY:=Base system
  TITLE:=Keenetic EULA document files (UK)
  DEPENDS:=+libc +SSP_SUPPORT:libssp base-files +keenetic-eula-common
  DISABLE_RSTRIP:=y
endef

define Package/keenetic-eula-uk/install
	if [ -d ./files-keenetic-eula-uk ]; then \
		$(CP) ./files-keenetic-eula-uk/* $(1); \
	fi
endef

$(eval $(call BuildPackage,keenetic-eula-uk))

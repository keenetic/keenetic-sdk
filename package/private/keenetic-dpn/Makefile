#
# Copyright (C) 2022 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=keenetic-dpn
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define Package/keenetic-dpn-common
  CATEGORY:=Base system
  TITLE:=Keenetic DPN document files (common)
  DEPENDS:=+libc +SSP_SUPPORT:libssp @!NO_DPN base-files
  DISABLE_RSTRIP:=y
endef

define Package/keenetic-dpn-common/install
	if [ -d ./files-keenetic-dpn-common ]; then \
		$(CP) ./files-keenetic-dpn-common/* $(1); \
	fi
endef

$(eval $(call BuildPackage,keenetic-dpn-common))

define Package/keenetic-dpn-de
  CATEGORY:=Base system
  TITLE:=Keenetic DPN document files (DE)
  DEPENDS:=+libc +SSP_SUPPORT:libssp @!NO_DPN base-files +keenetic-dpn-common
  DISABLE_RSTRIP:=y
endef

define Package/keenetic-dpn-de/install
	if [ -d ./files-keenetic-dpn-de ]; then \
		$(CP) ./files-keenetic-dpn-de/* $(1); \
	fi
endef

$(eval $(call BuildPackage,keenetic-dpn-de))

define Package/keenetic-dpn-en
  CATEGORY:=Base system
  TITLE:=Keenetic DPN document files (EN)
  DEPENDS:=+libc +SSP_SUPPORT:libssp @!NO_DPN base-files +keenetic-dpn-common
  DISABLE_RSTRIP:=y
endef

define Package/keenetic-dpn-en/install
	if [ -d ./files-keenetic-dpn-en ]; then \
		$(CP) ./files-keenetic-dpn-en/* $(1); \
	fi
endef

$(eval $(call BuildPackage,keenetic-dpn-en))

define Package/keenetic-dpn-es
  CATEGORY:=Base system
  TITLE:=Keenetic DPN document files (ES)
  DEPENDS:=+libc +SSP_SUPPORT:libssp @!NO_DPN base-files +keenetic-dpn-common
  DISABLE_RSTRIP:=y
endef

define Package/keenetic-dpn-es/install
	if [ -d ./files-keenetic-dpn-es ]; then \
		$(CP) ./files-keenetic-dpn-es/* $(1); \
	fi
endef

$(eval $(call BuildPackage,keenetic-dpn-es))

define Package/keenetic-dpn-fr
  CATEGORY:=Base system
  TITLE:=Keenetic DPN document files (FR)
  DEPENDS:=+libc +SSP_SUPPORT:libssp @!NO_DPN base-files +keenetic-dpn-common
  DISABLE_RSTRIP:=y
endef

define Package/keenetic-dpn-fr/install
	if [ -d ./files-keenetic-dpn-fr ]; then \
		$(CP) ./files-keenetic-dpn-fr/* $(1); \
	fi
endef

$(eval $(call BuildPackage,keenetic-dpn-fr))

define Package/keenetic-dpn-it
  CATEGORY:=Base system
  TITLE:=Keenetic DPN document files (IT)
  DEPENDS:=+libc +SSP_SUPPORT:libssp @!NO_DPN base-files +keenetic-dpn-common
  DISABLE_RSTRIP:=y
endef

define Package/keenetic-dpn-it/install
	if [ -d ./files-keenetic-dpn-it ]; then \
		$(CP) ./files-keenetic-dpn-it/* $(1); \
	fi
endef

$(eval $(call BuildPackage,keenetic-dpn-it))

define Package/keenetic-dpn-pl
  CATEGORY:=Base system
  TITLE:=Keenetic DPN document files (PL)
  DEPENDS:=+libc +SSP_SUPPORT:libssp @!NO_DPN base-files +keenetic-dpn-common
  DISABLE_RSTRIP:=y
endef

define Package/keenetic-dpn-pl/install
	if [ -d ./files-keenetic-dpn-pl ]; then \
		$(CP) ./files-keenetic-dpn-pl/* $(1); \
	fi
endef

$(eval $(call BuildPackage,keenetic-dpn-pl))

define Package/keenetic-dpn-pt
  CATEGORY:=Base system
  TITLE:=Keenetic DPN document files (PT)
  DEPENDS:=+libc +SSP_SUPPORT:libssp @!NO_DPN base-files +keenetic-dpn-common
  DISABLE_RSTRIP:=y
endef

define Package/keenetic-dpn-pt/install
	if [ -d ./files-keenetic-dpn-pt ]; then \
		$(CP) ./files-keenetic-dpn-pt/* $(1); \
	fi
endef

$(eval $(call BuildPackage,keenetic-dpn-pt))

define Package/keenetic-dpn-ru
  CATEGORY:=Base system
  TITLE:=Keenetic DPN document files (RU)
  DEPENDS:=+libc +SSP_SUPPORT:libssp @!NO_DPN base-files +keenetic-dpn-common
  DISABLE_RSTRIP:=y
endef

define Package/keenetic-dpn-ru/install
	if [ -d ./files-keenetic-dpn-ru ]; then \
		$(CP) ./files-keenetic-dpn-ru/* $(1); \
	fi
endef

$(eval $(call BuildPackage,keenetic-dpn-ru))

define Package/keenetic-dpn-sv
  CATEGORY:=Base system
  TITLE:=Keenetic DPN document files (SV)
  DEPENDS:=+libc +SSP_SUPPORT:libssp @!NO_DPN base-files +keenetic-dpn-common
  DISABLE_RSTRIP:=y
endef

define Package/keenetic-dpn-sv/install
	if [ -d ./files-keenetic-dpn-sv ]; then \
		$(CP) ./files-keenetic-dpn-sv/* $(1); \
	fi
endef

$(eval $(call BuildPackage,keenetic-dpn-sv))

define Package/keenetic-dpn-tr
  CATEGORY:=Base system
  TITLE:=Keenetic DPN document files (TR)
  DEPENDS:=+libc +SSP_SUPPORT:libssp @!NO_DPN base-files +keenetic-dpn-common
  DISABLE_RSTRIP:=y
endef

define Package/keenetic-dpn-tr/install
	if [ -d ./files-keenetic-dpn-tr ]; then \
		$(CP) ./files-keenetic-dpn-tr/* $(1); \
	fi
endef

$(eval $(call BuildPackage,keenetic-dpn-tr))

define Package/keenetic-dpn-uk
  CATEGORY:=Base system
  TITLE:=Keenetic DPN document files (UK)
  DEPENDS:=+libc +SSP_SUPPORT:libssp @!NO_DPN base-files +keenetic-dpn-common
  DISABLE_RSTRIP:=y
endef

define Package/keenetic-dpn-uk/install
	if [ -d ./files-keenetic-dpn-uk ]; then \
		$(CP) ./files-keenetic-dpn-uk/* $(1); \
	fi
endef

$(eval $(call BuildPackage,keenetic-dpn-uk))

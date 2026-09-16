#
# Copyright (C) 2026 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=fbfdloader
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define Package/fbfdloader
  CATEGORY:=Base system
  TITLE:=Firmware update utility for Simcom ASR modems
  DEPENDS:=+libc +SSP_SUPPORT:libssp @HAS_EMB_MODEM
  DISABLE_RSTRIP:=y
endef

define Package/fbfdloader/install
	if [ -d ./files-fbfdloader ]; then \
		$(CP) ./files-fbfdloader/* $(1); \
	fi
endef

$(eval $(call BuildPackage,fbfdloader))

#
# Copyright (C) 2021 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=fwupdate
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define Package/fwupdate
  CATEGORY:=Base system
  TITLE:=Firmware update utility for NDM
  DEPENDS:=+libc +SSP_SUPPORT:libssp +kmod-phr +libndmfw +libndm +libopenssl
  DISABLE_RSTRIP:=y
endef

define Package/fwupdate/install
	if [ -d ./files-fwupdate ]; then \
		$(CP) ./files-fwupdate/* $(1); \
	fi
endef

$(eval $(call BuildPackage,fwupdate))

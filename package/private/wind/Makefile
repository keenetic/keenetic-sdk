#
# Copyright (C) 2023 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=wind
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define Package/wind
  CATEGORY:=Network
  TITLE:=Wireless network daemon
  DEPENDS:=+libc +SSP_SUPPORT:libssp +libndm +libopenssl
  DISABLE_RSTRIP:=y
endef

define Package/wind/install
	if [ -d ./files-wind ]; then \
		$(CP) ./files-wind/* $(1); \
	fi
endef

$(eval $(call BuildPackage,wind))

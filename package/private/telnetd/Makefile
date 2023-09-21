#
# Copyright (C) 2023 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=telnetd
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define Package/telnetd
  CATEGORY:=Network
  TITLE:=Lightweight telnet daemon for NDM
  DEPENDS:=+libc +SSP_SUPPORT:libssp +libndm
  DISABLE_RSTRIP:=y
endef

define Package/telnetd/install
	if [ -d ./files-telnetd ]; then \
		$(CP) ./files-telnetd/* $(1); \
	fi
endef

$(eval $(call BuildPackage,telnetd))

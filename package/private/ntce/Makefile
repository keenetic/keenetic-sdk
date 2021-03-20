#
# Copyright (C) 2021 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=ntce
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define Package/ntce
  CATEGORY:=Network
  TITLE:=Traffic identification engine
  DEPENDS:=+libc +SSP_SUPPORT:libssp +libndm +libpcap +kmod-ntce-nf +kmod-dummy
  DISABLE_RSTRIP:=y
endef

define Package/ntce/install
	if [ -d ./files-ntce ]; then \
		$(CP) ./files-ntce/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ntce))

#
# Copyright (C) 2022 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=npdump
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define Package/npdump
  CATEGORY:=Network
  TITLE:=A small packet capturing utility for NDM
  DEPENDS:=+libc +SSP_SUPPORT:libssp +libndm +libpcap
  DISABLE_RSTRIP:=y
endef

define Package/npdump/install
	if [ -d ./files-npdump ]; then \
		$(CP) ./files-npdump/* $(1); \
	fi
endef

$(eval $(call BuildPackage,npdump))

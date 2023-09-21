#
# Copyright (C) 2023 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=libc-test
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define Package/libc-test
  CATEGORY:=Debug suite
  TITLE:=Test suite for Libc
  DEPENDS:=+libc +SSP_SUPPORT:libssp
  DISABLE_RSTRIP:=y
endef

define Package/libc-test/install
	if [ -d ./files-libc-test ]; then \
		$(CP) ./files-libc-test/* $(1); \
	fi
endef

$(eval $(call BuildPackage,libc-test))

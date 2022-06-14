#
# Copyright (C) 2021 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=mini_snmpd
PKG_VERSION:=1.4-20

PKG_SOURCE_URL:=$(NDM_STORAGE)/$(PKG_NAME)
PKG_SOURCE_VERSION:=$(PKG_VERSION)
PKG_SOURCE_PROTO:=git

PKG_LICENSE:=GPL-2.0

PKG_FIXUP:=autoreconf

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/ndm-build.mk

EXTRA_CPPFLAGS := -DNDM

EXTRA_CFLAGS   := -Wall \
                  -Winit-self \
                  -Wmissing-field-initializers \
                  -Wpointer-arith \
                  -Wredundant-decls \
                  -Wshadow \
                  -Wstrict-aliasing \
                  -Wswitch-enum \
                  -Wundef \
                  -Wunsafe-loop-optimizations \
                  -fdata-sections \
                  -ffunction-sections \
                  -fno-strict-aliasing \
                  -ftabstop=4

EXTRA_LDFLAGS  := -Wl,--gc-section -lndm

define Package/mini_snmpd
  SECTION:=net
  CATEGORY:=Network
  TITLE:=Lightweight SNMP daemon
  URL:=http://troglobit.github.io/mini-snmpd.html
  DEPENDS:=+libndm
endef

define Package/mini_snmpd/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(CP) $(PKG_BUILD_DIR)/mini_snmpd $(1)/usr/sbin
endef

$(eval $(call BuildPackage,mini_snmpd))

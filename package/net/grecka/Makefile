#
# Copyright (C) 2018-2020 NDM Systems, Inc. http://www.ndmsystems.com/
#

include $(TOPDIR)/rules.mk

PKG_NAME:=grecka
PKG_VERSION:=0.8
PKG_LICENSE:=BSD

PKG_SOURCE_URL:=$(NDM_STORAGE)/$(PKG_NAME)
PKG_SOURCE_VERSION:=$(PKG_VERSION)
PKG_SOURCE_PROTO:=git

include $(INCLUDE_DIR)/package.mk

EXTRA_CPPFLAGS := -D_LARGEFILE_SOURCE \
                  -D_LARGEFILE64_SOURCE \
                  -D_FILE_OFFSET_BITS=64 \
                  -D_GNU_SOURCE

EXTRA_CFLAGS   := -std=c99 \
                  -Wall \
                  -Wconversion \
                  -Winit-self \
                  -Wmissing-field-initializers \
                  -Wpointer-arith \
                  -Wredundant-decls \
                  -Wshadow \
                  -Wswitch-enum \
                  -Wundef \
                  -Wunsafe-loop-optimizations \
                  -fdata-sections \
                  -ffunction-sections \
                  -ftabstop=4

EXTRA_LDFLAGS  := -Wl,--gc-section -lndm

define Package/$(PKG_NAME)
  NAME:=$(PKG_NAME)
  SECTION:=net
  CATEGORY:=Network
  TITLE:=Daemon for handling Cisco-like GRE keepalive
  DEPENDS:=+kmod-gre +libndm
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/greckad $(1)/usr/sbin
endef

$(eval $(call BuildPackage,$(PKG_NAME)))

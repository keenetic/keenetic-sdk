#
# Copyright (C) 2018-2020 NDM Systems, Inc. http://www.ndmsystems.com/
#

include $(TOPDIR)/rules.mk

PKG_NAME:=nlldp
PKG_VERSION:=0.12
PKG_LICENSE:=BSD

PKG_SOURCE_URL:=$(NDM_STORAGE)/$(PKG_NAME)
PKG_SOURCE_VERSION:=$(PKG_VERSION)
PKG_SOURCE_PROTO:=git

include $(INCLUDE_DIR)/package.mk

EXTRA_CPPFLAGS := -D_LARGEFILE_SOURCE \
                  -D_LARGEFILE64_SOURCE \
                  -D_FILE_OFFSET_BITS=64 \
                  -D_GNU_SOURCE

EXTRA_CFLAGS   := -Wall \
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
                  -fno-strict-aliasing \
                  -ftabstop=4 \
                  -std=c99

EXTRA_LDFLAGS  := -Wl,--gc-section -lndm

define Package/$(PKG_NAME)
  NAME:=$(PKG_NAME)
  SECTION:=net
  CATEGORY:=Network
  TITLE:=Simple LLDP agent and observer daemons
  DEPENDS:=+libndm
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/nlldo $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/nllda $(1)/usr/sbin
endef

$(eval $(call BuildPackage,$(PKG_NAME)))

#
# Copyright (C) 2011-2020 NDM Systems, Inc. http://www.ndmsystems.com/
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/libndm.mk

PKG_NAME:=libndm
PKG_VERSION:=$(LIBNDM_VERSION)
PKG_LICENSE:=NDM

PKG_SOURCE_URL:=$(NDM_STORAGE)/$(PKG_NAME)
PKG_SOURCE_VERSION:=$(PKG_VERSION)
PKG_SOURCE_PROTO:=git

ifneq ($(CONFIG_USE_MKLIBS),)
  TARGET_LTO_FLAGS :=
endif

include $(INCLUDE_DIR)/package.mk

define Package/libndm
  SECTION:=libs
  CATEGORY:=Libraries
  TITLE:=NDM common library
  URL:=http://ndmsystems.com/
  DEPENDS:=+libpthread +librt
endef

EXTRA_CPPFLAGS := -D_LARGEFILE_SOURCE \
                  -D_LARGEFILE64_SOURCE \
                  -D_FILE_OFFSET_BITS=64 \
                  -D_POSIX_C_SOURCE=200112L \
                  -D_DEFAULT_SOURCE \
                  -DNDEBUG \
                  -I$(PKG_BUILD_DIR)/include

ifneq ($(CONFIG_PACKAGE_ndm-mod-storage),)
EXTRA_CPPFLAGS += -DLIBNDM_SBCS_SUPPORT
endif

EXTRA_CFLAGS   := $(FPIC) \
                  -std=c99 \
                  -pthread \
                  -ffunction-sections \
                  -fdata-sections \
                  -Wall \
                  -Winit-self \
                  -Wswitch-enum \
                  -Wundef  \
                  -Wmissing-field-initializers \
                  -Wredundant-decls \
                  -Wstack-protector \
                  -ftabstop=4 \
                  -Wshadow \
                  -Wpointer-arith

EXTRA_LDFLAGS  := $(FPIC) -pthread

define Build/Compile
	$(call Build/Compile/Default)
	$(call Build/Compile/Default,static)
endef

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/lib
	$(INSTALL_DIR) $(1)/usr/include
	$(CP) $(PKG_BUILD_DIR)/libndm.so* $(1)/usr/lib/
	$(CP) -R $(PKG_BUILD_DIR)/include/ndm $(1)/usr/include/
endef

define Package/libndm/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_BUILD_DIR)/libndm.so* $(1)/usr/lib/
endef

define Package/libndm/install_lib
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_BUILD_DIR)/libndm.a $(1)/usr/lib/libndm_pic.a
endef

$(eval $(call BuildPackage,libndm))

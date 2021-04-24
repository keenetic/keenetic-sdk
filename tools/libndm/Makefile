#
# Copyright (C) 2017-2018 NDM Systems, Inc. http://www.ndmsystems.com/
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/libndm.mk

PKG_NAME:=libndm
PKG_VERSION:=$(LIBNDM_VERSION)
PKG_RELEASE:=1
PKG_LICENSE:=NDM

PKG_SOURCE_URL:=$(NDM_STORAGE)/$(PKG_NAME)
PKG_SOURCE_VERSION:=$(PKG_VERSION)
PKG_SOURCE_PROTO:=git

include $(INCLUDE_DIR)/host-build.mk

HOST_CPPFLAGS := -D_LARGEFILE_SOURCE \
                 -D_LARGEFILE64_SOURCE \
                 -D_FILE_OFFSET_BITS=64 \
                 -D_POSIX_C_SOURCE=200809L \
                 -D_DEFAULT_SOURCE \
                 -D_BSD_SOURCE \
                 -DNDEBUG \
                 -I$(HOST_BUILD_DIR)/include

HOST_CFLAGS   := -pipe -std=c99 -O2 \
                 -pthread \
                 -ffunction-sections \
                 -fdata-sections \
                 -fstack-protector-all \
                 -ftabstop=4 \
                 -Wempty-body -Wall -Winit-self -Wswitch-enum -Wundef \
                 -Waddress -Wmissing-field-initializers -Wconversion \
                 -Wredundant-decls -Wvla -Wstack-protector -Wshadow \
                 -Wpointer-arith -Wtype-limits -Werror

HOST_LDFLAGS  := -pthread -Wl,--gc-section

HOST_MAKE_FLAGS = \
	CC="$(HOSTCC)" \
	CFLAGS="$(HOST_CFLAGS)" \
	CPPFLAGS="$(HOST_CPPFLAGS)" \
	LDFLAGS="$(HOST_LDFLAGS)" \
	SHELL="$(BASH)"

define Host/Compile
  $(call Host/Compile/Default,static)
endef

define Host/Install
	$(INSTALL_DIR) $(STAGING_DIR_HOST)/usr/lib
	$(INSTALL_DIR) $(STAGING_DIR_HOST)/usr/include
	$(INSTALL_BIN) $(HOST_BUILD_DIR)/libndm.a $(STAGING_DIR_HOST)/usr/lib/
	$(CP) $(HOST_BUILD_DIR)/include/ndm $(STAGING_DIR_HOST)/usr/include/
endef

define Host/Clean
	rm -f $(STAGING_DIR_HOST)/usr/lib/libndm.a
	rm -rf $(STAGING_DIR_HOST)/usr/include/ndm
	$(call Host/Clean/Default)
endef

$(eval $(call HostBuild))

#
# Copyright (C) 2019-2020 NDM Systems, Inc. http://www.ndmsystems.com/
#

include $(TOPDIR)/rules.mk

PKG_NAME:=tze
PKG_VERSION:=1.1.0
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
                 -I$(STAGING_DIR_HOST)/usr/include

HOST_CFLAGS   := -pipe \
                 -std=c99 \
                 -O2 \
                 -ffunction-sections \
                 -fdata-sections \
                 -fstack-protector-all \
                 -ftabstop=4 \
                 -Wall \
                 -Wconversion \
                 -Werror \
                 -Winit-self \
                 -Wmissing-field-initializers \
                 -Wshadow \
                 -Wstack-protector \
                 -Wswitch-enum \
                 -Wtype-limits \
                 -Wundef \
                 -Wvla \
                 -Waddress \
                 -Wempty-body \
                 -Wpointer-arith \
                 -Wredundant-decls

HOST_LDFLAGS  := -L$(STAGING_DIR_HOST)/usr/lib -Wl,--gc-section

HOST_MAKE_FLAGS = \
	CC="$(HOSTCC)" \
	CFLAGS="$(HOST_CFLAGS)" \
	CPPFLAGS="$(HOST_CPPFLAGS)" \
	LDFLAGS="$(HOST_LDFLAGS)" \
	SHELL="$(BASH)"

define Host/Install
	$(INSTALL_DIR) $(STAGING_DIR_HOST)/bin
	$(INSTALL_BIN) $(HOST_BUILD_DIR)/tze $(STAGING_DIR_HOST)/bin/
endef

define Host/Clean
	rm -f $(STAGING_DIR_HOST)/bin/tze
	$(call Host/Clean/Default)
endef

$(eval $(call HostBuild))

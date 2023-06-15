#
# Copyright (C) 2021 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=transmission
PKG_VERSION:=3.00-11
PKG_LICENSE:=GPL-2.0 GPL-3.0

PKG_SOURCE_URL:=$(NDM_STORAGE)/$(PKG_NAME)
PKG_SOURCE_VERSION:=$(PKG_VERSION)
PKG_SOURCE_PROTO:=git

PKG_GIT_SUBMODULES:=1

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/ndm-build.mk

define Package/transmission/template
  SECTION:=net
  CATEGORY:=Network
  TITLE:=A free, lightweight BitTorrent client
  URL:=http://www.transmissionbt.com
endef

define Package/transmission-daemon
  $(call Package/transmission/template)
  DEPENDS:=+zlib +libcurl +libopenssl +libevent +libpthread +libndm
  DEPENDS+=+TRANSMISSION_DAEMON_BACKTRACE:libfatalsig
  MENU:=1
endef

define Package/transmission-daemon/config
	source "$(SOURCE)/transmission.in"
endef

define Package/transmission-daemon/description
 Transmission is a simple BitTorrent client.
 It features a very simple, intuitive interface
 on top on an efficient, cross-platform back-end.
 This package contains the daemon itself.
endef

TR_CPPFLAGS      := -D_DEFAULT_SOURCE
TR_CFLAGS        := -std=gnu99 -pthread
TR_LDFLAGS       :=

CONFIGURE_VARS   += LIBEVENT_LIBS="$(STAGING_DIR)/usr/lib/libevent.so" \
                    LIBEVENT_CFLAGS="-I $(STAGING_DIR)/usr/include"

CONFIGURE_ARGS   += --enable-daemon \
                    --enable-utp \
                    --enable-largefile \
                    --enable-lightweight \
                    --disable-cli \
                    --disable-dependency-tracking \
                    --without-gtk \
                    --without-systemd-daemon

ifeq ($(CONFIG_TRANSMISSION_DAEMON_BACKTRACE),y)
TARGET_CFLAGS    := $(filter-out \
						-fno-asynchronous-unwind-tables \
						-fomit-frame-pointer \
						-fno-caller-saves \
						, $(TARGET_CFLAGS)) \
					-fasynchronous-unwind-tables \
					-fno-omit-frame-pointer \
					-fcaller-saves
CONFIGURE_ARGS   += --with-libfatalsig
RSTRIP			 := :
STRIP			 := :
endif

MAKE_FLAGS       += CFLAGS="$(TARGET_CFLAGS) $(TR_CFLAGS) $(TARGET_CPPFLAGS) $(TR_CPPFLAGS)" \
                    LDFLAGS="$(TARGET_LDFLAGS) $(TR_LDFLAGS)"

define Build/Configure
	(cd $(PKG_BUILD_DIR); AUTOGEN_SUBDIR_MODE=1 ./autogen.sh );
	$(call Build/Configure/Default)
endef

define Package/transmission-daemon/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/daemon/transmission-daemon $(1)/usr/sbin/transmissiond
endef

$(eval $(call BuildPackage,transmission-daemon))

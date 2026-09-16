#
# Copyright (C) 2006-2012 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=gdb
PKG_VERSION:=8.3.1
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.xz
PKG_SOURCE_URL:=@GNU/gdb
PKG_HASH:=1e55b4d7cdca7b34be12f4ceae651623aa73b2fd640152313f9f66a7149757c4

include $(INCLUDE_DIR)/package.mk

define Package/gdb/Default
  SECTION:=debug
  CATEGORY:=Debug suite
  URL:=http://www.gnu.org/software/gdb/
endef

define Package/gdb
$(call Package/gdb/Default)
  TITLE:=GNU Debugger
  DEPENDS+=+libncurses +zlib +libthread-db
endef

define Package/gdb/description
GDB, the GNU Project debugger, allows you to see what is going on `inside'
another program while it executes -- or what another program was doing at the
moment it crashed.
endef

define Package/gdbserver
$(call Package/gdb/Default)
  TITLE:=Remote server for GNU Debugger
endef

define Package/gdbserver/description
GDBSERVER is a program that allows you to run GDB on a different machine than the
one which is running the program being debugged.
endef

GDBINIT         := /etc/gdbinit

CONFIGURE_ARGS  += --without-expat

CONFIGURE_ARGS  += --disable-gdbtk \
                   --disable-multi-ice \
                   --disable-sim \
                   --disable-tui \
                   --disable-werror \
                   --disable-source-highlight \
                   --enable-gdbserver \
                   --without-develop \
                   --without-expat \
                   --without-included-gettext \
                   --without-uiout \
                   --without-x \
                   --with-system-gdbinit=$(GDBINIT) \
                   --with-system-zlib

# optimize for size, disable LTO
OLD_OPTS        := -O0 -O1 -O2 -O3 -Os $(TARGET_LTO_FLAGS)
NEW_OPTS        := -Os -ffunction-sections -fdata-sections
TARGET_CFLAGS   := $(filter-out $(OLD_OPTS),$(TARGET_CFLAGS)) $(NEW_OPTS)
TARGET_CXXFLAGS := $(filter-out $(OLD_OPTS),$(TARGET_CXXFLAGS)) $(NEW_OPTS)
TARGET_LDFLAGS  := $(filter-out $(OLD_OPTS),$(TARGET_LDFLAGS)) -Os -static-libstdc++ -Wl,--gc-sections

# disable -fhonour-copts checking
export GCC_HONOUR_COPTS=s

define Build/Compile
	+$(MAKE) $(PKG_JOBS) -C $(PKG_BUILD_DIR) \
		DESTDIR="$(PKG_INSTALL_DIR)" \
		all
	$(MAKE) -C $(PKG_BUILD_DIR) \
		DESTDIR="$(PKG_INSTALL_DIR)" \
		install-gdb
endef

define Package/gdb/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/gdb $(1)/usr/bin/
	$(INSTALL_DIR) $(1)$(dir $(GDBINIT))
	echo "set auto-load safe-path /"           > $(1)$(GDBINIT)
	echo "set auto-solib-add off"             >> $(1)$(GDBINIT)
	echo "set print thread-events off"        >> $(1)$(GDBINIT)
	echo "set print inferior-events off"      >> $(1)$(GDBINIT)
	echo "handle SIGILL nostop noprint pass"  >> $(1)$(GDBINIT)
	echo "handle SIGPIPE nostop noprint pass" >> $(1)$(GDBINIT)
endef

define Package/gdbserver/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/gdbserver $(1)/usr/bin/
endef

$(eval $(call BuildPackage,gdb))
$(eval $(call BuildPackage,gdbserver))

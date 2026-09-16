#
# Copyright (C) 2007-2018 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=util-linux
PKG_VERSION:=2.34
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.xz
PKG_SOURCE_URL:=@KERNEL/linux/utils/$(PKG_NAME)/v2.34
PKG_HASH:=743f9d0c7252b6db246b659c1e1ce0bd45d8d4508b4dfa427bbb4a3e9b9f62b5

PKG_LICENSE:=LGPL-2.1
PKG_LICENSE_FILES:=Documentation/licenses/COPYING.LGPL-2.1-or-later

PKG_BUILD_PARALLEL:=1

PKG_FIXUP:=autoreconf
PKG_INSTALL:=1

DISABLE_NLS:=--disable-nls

include $(INCLUDE_DIR)/package.mk

define Package/util-linux/Default
  SECTION:=utils
  CATEGORY:=Utilities
  DEPENDS:= +librt
  URL:=http://www.kernel.org/pub/linux/utils/util-linux/
endef

define Package/libuuid
$(call Package/util-linux/Default)
  TITLE:=DCE compatible Universally Unique Identifier library
  SECTION:=libs
  CATEGORY:=Libraries
  ABI_VERSION:=1
endef

define Package/libuuid/description
 The UUID library is used to generate unique identifiers for objects
 that may be accessible beyond the local system. This library
 generates UUIDs compatible with those created by the Open Software
 Foundation (OSF) Distributed Computing Environment (DCE) utility.
endef

CONFIGURE_ARGS += \
	--disable-shared \
	--enable-static \
	--disable-use-tty-group		\
	--disable-rpath			\
	--disable-tls			\
	--disable-su			\
	--disable-sulogin		\
	--disable-makeinstall-chown	\
	--disable-login 		\
	--disable-nologin		\
	--disable-lslogins		\
	--disable-runuser		\
	--disable-chfn-chsh		\
	--without-python		\
	--without-udev			\
	--without-readline		\
	--without-ncursesw		\
	--without-ncurses		\
	--without-tinfo			\
	--without-util			\
	--without-audit			\
	--without-selinux		\
	--without-slang			\
	--without-readline		\
	--without-cap-ng		\
	--without-user			\
	--without-btrfs			\
	--without-systemd		\
	--without-smack			\
	--disable-widechar		\
	--disable-all-programs	\
	--disable-colors-default \
	--enable-libuuid

TARGET_CFLAGS += $(FPIC) -std=gnu99

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/lib/pkgconfig
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/pkgconfig/uuid.pc $(1)/usr/lib/pkgconfig

	$(INSTALL_DIR) $(1)/usr/include/uuid
	$(CP) $(PKG_INSTALL_DIR)/usr/include/uuid/uuid.h $(1)/usr/include/uuid

	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libuuid.{a,la} $(1)/usr/lib
endef

define Package/libuuid/install
	$(INSTALL_DIR) $(1)/usr/lib
endef

$(eval $(call BuildPackage,libuuid))

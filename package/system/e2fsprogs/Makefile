#
# Copyright (C) 2006-2014 OpenWrt.org
# Copyright 2010 Vertical Communications
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=e2fsprogs
PKG_VERSION:=1.46.5
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.xz
PKG_SOURCE_URL:=@KERNEL/linux/kernel/people/tytso/e2fsprogs/v$(PKG_VERSION)/
PKG_HASH:=2f16c9176704cf645dc69d5b15ff704ae722d665df38b2ed3cfc249757d8d81e

PKG_LICENSE:=GPL-2.0
PKG_LICENSE_FILES:=NOTICE

PKG_INSTALL:=1

include $(INCLUDE_DIR)/package.mk

define Package/e2fsprogs
  SECTION:=utils
  CATEGORY:=Utilities
  SUBMENU:=Filesystem
  TITLE:=Ext2/3/4 filesystem utilities
  URL:=http://e2fsprogs.sourceforge.net/
  DEPENDS:=+libext2fs
endef

define Package/e2fsprogs/description
 This package contains essential ext2 filesystem utilities which consists of
 e2fsck, mke2fs and most of the other core ext2 filesystem utilities.
endef

define Package/libext2fs
  SECTION:=libs
  CATEGORY:=Libraries
  TITLE:=ext2/3/4 filesystem library
  URL:=http://e2fsprogs.sourceforge.net/
  DEPENDS:=+libss +libcomerr
  ABI_VERSION:=2
endef

define Package/libext2fs/description
 libext2fs is a library which can access ext2, ext3 and ext4 filesystems.
endef

define Package/libss
  SECTION:=libs
  CATEGORY:=Libraries
  TITLE:=command-line interface parsing library
  URL:=http://e2fsprogs.sourceforge.net/
  DEPENDS:=+libcomerr
  ABI_VERSION:=2
endef

define Package/libss/description
  This pacakge contains libss, a command-line interface parsing library
  bundled with e2fsprogs.
endef

define Package/libcomerr
  SECTION:=libs
  CATEGORY:=Libraries
  TITLE:=common error description library
  URL:=http://e2fsprogs.sourceforge.net/
  DEPENDS:=+librt +libpthread
  ABI_VERSION:=0
endef

define Package/libcomerr/description
  This package contains libcom_err, the common error description library
  bundled with e2fsprogs.
endef

TARGET_CFLAGS += $(FPIC) -ffunction-sections -fdata-sections -flto

TARGET_LDFLAGS += $(if $(CONFIG_USE_GLIBC),-lrt)
TARGET_LDFLAGS += -flto

CONFIGURE_ARGS += \
	--disable-testio-debug \
	--enable-elf-shlibs	\
	--enable-libuuid	\
	--enable-libblkid	\
	--disable-uuidd		\
	--disable-tls		\
	--disable-nls		\
	--disable-rpath		\
	--disable-fuse2fs	\
	--disable-backtrace	\
	--disable-debugfs	\
	--disable-imager	\
	--disable-resizer	\
	--disable-defrag	\
	--disable-tdb

define Build/Prepare
	$(call Build/Prepare/Default)
	$(CP) $(SCRIPT_DIR)/config.{guess,sub} $(PKG_BUILD_DIR)/config/
endef

define Build/Compile
	+$(MAKE) $(PKG_JOBS) -C $(PKG_BUILD_DIR)/util \
		BUILDCC="$(HOSTCC)" \
		CFLAGS="" \
		CPPFLAGS="" \
		LDFLAGS="" \
		subst
	+$(MAKE) $(PKG_JOBS) -C $(PKG_BUILD_DIR) \
		LDFLAGS=-Wl,--gc-sections \
		BUILDCC="$(HOSTCC)" \
		DESTDIR="$(PKG_INSTALL_DIR)" \
		SYSLIBS="$(TARGET_LDFLAGS) -ldl -L$(PKG_BUILD_DIR)/lib/ -l:libcom_err.so.0.0" \
		all
endef

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/lib/pkgconfig
	$(CP) $(PKG_BUILD_DIR)/lib/ext2fs/ext2fs.pc $(1)/usr/lib/pkgconfig
	$(CP) $(PKG_BUILD_DIR)/lib/et/com_err.pc $(1)/usr/lib/pkgconfig

	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_BUILD_DIR)/lib/libext2fs.{so,a}* $(1)/usr/lib
	$(CP) $(PKG_BUILD_DIR)/lib/libcom_err.{so,a}* $(1)/usr/lib
	$(CP) $(PKG_BUILD_DIR)/lib/libss.{so,a}* $(1)/usr/lib

	$(INSTALL_DIR) $(1)/usr/include/ext2fs
	$(CP) $(PKG_BUILD_DIR)/lib/ext2fs/*.h $(1)/usr/include/ext2fs
	$(INSTALL_DIR) $(1)/usr/include/et
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/lib/et/*.h $(1)/usr/include/et
	# Apparently there is some confusion
	echo "#include <et/com_err.h>" > $(1)/usr/include/com_err.h
	$(INSTALL_DIR) $(1)/usr/include/ss
	$(CP) \
		$(PKG_BUILD_DIR)/lib/ss/ss.h \
		$(PKG_BUILD_DIR)/lib/ss/ss_err.h \
		$(1)/usr/include/ss/
endef

define Package/e2fsprogs/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/sbin/e2fsck $(1)/usr/sbin/e2fsck-fw
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/sbin/mke2fs $(1)/usr/sbin/mke2fs-fw
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libe2p.so.* $(1)/usr/lib/
	$(INSTALL_DIR) $(1)/etc
	$(INSTALL_DATA) ./files/e2fsck.conf $(1)/etc/e2fsck.conf
endef

define Package/libcomerr/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libcom_err.so.* $(1)/usr/lib/
endef

define Package/libss/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libss.so.* $(1)/usr/lib/
endef

define Package/libext2fs/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libblkid.so.* $(1)/usr/lib/
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libuuid.so.* $(1)/usr/lib/
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libext2fs.so.* $(1)/usr/lib/
endef

$(eval $(call BuildPackage,e2fsprogs))
$(eval $(call BuildPackage,libcomerr))
$(eval $(call BuildPackage,libss))
$(eval $(call BuildPackage,libext2fs))

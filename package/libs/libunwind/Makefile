#
# Copyright (C) 2008-2016 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=libunwind
PKG_VERSION:=v1.5-rc1-ndm-4
PKG_LICENSE:=FREE

PKG_SOURCE_URL:=$(NDM_STORAGE)/$(PKG_NAME)
PKG_SOURCE_VERSION:=$(PKG_VERSION)
PKG_SOURCE_PROTO:=git

PKG_FIXUP=autoreconf

include $(INCLUDE_DIR)/package.mk

define Package/libunwind
  SECTION:=libs
  CATEGORY:=Libraries
  DEPENDS:=+zlib
  TITLE:=The libunwind project
  URL:=http://www.nongnu.org/libunwind/
endef

define Package/libunwind-ptrace
  SECTION:=libs
  CATEGORY:=Libraries
  DEPENDS:=+libunwind
  TITLE:=The libunwind project (ptrace addon)
  URL:=http://www.nongnu.org/libunwind/
endef

define Package/libunwind-arch
  SECTION:=libs
  CATEGORY:=Libraries
  DEPENDS:=+libunwind
  TITLE:=The libunwind project (arch addon)
  URL:=http://www.nongnu.org/libunwind/
endef

ifneq ($(findstring $(ARCH),aarch64),)
  LIBUNWIND_ARCH:=aarch64
else ifneq ($(findstring $(ARCH),mips mipsel),)
  LIBUNWIND_ARCH:=mips
else
  LIBUNWIND_ARCH:=unk
endif

define Package/libunwind/description
	The primary goal of this project is to define a portable and efficient C
	programming interface (API) to determine the call-chain of a program.
	The API additionally provides the means to manipulate the preserved
	(callee-saved) state of each call-frame and to resume execution
	at any point in the call-chain (non-local goto). The API supports both
	local (same-process) and remote (across-process) operation.
	As such, the API is useful in a number of applications.
endef

CONFIGURE_ARGS += \
	--enable-shared \
	--enable-debug-frame \
	--enable-conservative-checks \
	--enable-block-signals \
	--enable-zlibdebuginfo \
	--disable-static \
	--disable-debug \
	--disable-dependency-tracking \
	--disable-documentation \
	--disable-coredump \
	--disable-ptrace \
	--disable-setjmp \
	--disable-tests \
	--disable-cxx-exceptions \
	--disable-msabi-support \
	--disable-minidebuginfo \
	--disable-weak-backtrace

TARGET_CFLAGS += \
	-fcommon

define Build/Compile
	$(call Build/Compile/Default)
	$(MAKE) -C $(PKG_BUILD_DIR) DESTDIR=$(PKG_INSTALL_DIR) install
endef

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/include/*.h $(1)/usr/include
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libunwind*.so* $(1)/usr/lib
endef

define Package/libunwind/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libunwind.so* $(1)/usr/lib/
endef

define Package/libunwind-ptrace/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libunwind-ptrace.so* $(1)/usr/lib/
endef

define Package/libunwind-arch/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libunwind-$(LIBUNWIND_ARCH).so* $(1)/usr/lib/
endef

$(eval $(call BuildPackage,libunwind))
$(eval $(call BuildPackage,libunwind-arch))
$(eval $(call BuildPackage,libunwind-ptrace))

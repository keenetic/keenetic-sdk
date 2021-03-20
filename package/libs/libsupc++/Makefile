#
# Copyright (C) 2021 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=libsupc++
PKG_VERSION:=1
PKG_RELEASE:=1
PKG_LICENSE:=NDM

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)

ifneq ($(CONFIG_USE_MKLIBS),)
  TARGET_LTO_FLAGS :=
endif

include $(INCLUDE_DIR)/package.mk

define Package/libsupcxx
  NAME:=libsupc++
  SECTION:=libs
  CATEGORY:=Libraries
  DEPENDS:=+libpthread
  TITLE:=Base C++ library
  URL:=http://gcc.gnu.org/
endef

define Build/Prepare
	$(INSTALL_DIR) $(PKG_BUILD_DIR)
	cp -fp $$$$($(TARGET_CC) -print-file-name=libsupc++.a) $(PKG_BUILD_DIR)
	cd $(PKG_BUILD_DIR); \
		$(TARGET_CROSS)ar x libsupc++.a;
endef

define Build/Compile
	cd $(PKG_BUILD_DIR); \
		$(TARGET_CC) -nodefaultlibs $(FPIC) -shared -Wl,-soname,libsupc++.so *.o \
			-lgcc_s -lc -lpthread -o libsupc++.so
	$(INSTALL_DIR) $(PKG_INSTALL_DIR)
	$(CP) $(PKG_BUILD_DIR)/libsupc++.so $(PKG_INSTALL_DIR)/
endef

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_BUILD_DIR)/libsupc++.so $(1)/usr/lib/
endef

define Package/libsupcxx/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_BUILD_DIR)/libsupc++.so $(1)/usr/lib/
endef

define Package/libsupcxx/install_lib
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_BUILD_DIR)/libsupc++.a $(1)/usr/lib/libsupc++_pic.a
endef

$(eval $(call BuildPackage,libsupcxx))


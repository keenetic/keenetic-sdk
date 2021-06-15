#
# Copyright (C) 2021 NDM Systems, Inc. http://www.ndmsystems.com/
#

include $(TOPDIR)/rules.mk

PKG_NAME:=mimalloc
PKG_VERSION:=1.7.1-0
PKG_LICENSE:=MIT

PKG_SOURCE_URL:=$(NDM_STORAGE)/$(PKG_NAME)
PKG_SOURCE_VERSION:=$(PKG_VERSION)
PKG_SOURCE_PROTO:=git
PKG_DEBUG:=false

CMAKE_BINARY_SUBDIR:=out

ifeq ($(PKG_DEBUG),true)
  CMAKE_OPTIONS+=-DCMAKE_BUILD_TYPE=Debug
  RSTRIP:=true
  STRIP:=true
endif

CMAKE_OPTIONS+=\
 -DMI_OVERRIDE=OFF \
 -DMI_BUILD_TESTS=OFF \
 -DMI_BUILD_OBJECT=OFF \
 -DMI_BUILD_SHARED=OFF \
 -DMI_INSTALL_TOPLEVEL=ON

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/$(PKG_NAME)
  SECTION:=libs
  CATEGORY:=Libraries
  TITLE:=mimalloc general purpose allocator
  URL:=https://github.com/microsoft/mimalloc
  DEPENDS:=+librt +libatomic
endef

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include/mimalloc/
	$(INSTALL_DATA) $(PKG_INSTALL_DIR)/usr/include/mimalloc.h $(1)/usr/include/mimalloc/mimalloc.h

	$(INSTALL_DIR) $(1)/usr/lib/
	$(INSTALL_DATA) $(PKG_INSTALL_DIR)/usr/libmimalloc.a $(1)/usr/lib/
endef

$(eval $(call BuildPackage,$(PKG_NAME)))

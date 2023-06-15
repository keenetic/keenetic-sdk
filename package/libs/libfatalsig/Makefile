#
# Copyright (C) 2016-2020 NDM Systems, Inc. http://www.ndmsystems.com/
#

include $(TOPDIR)/rules.mk

PKG_NAME:=libfatalsig
PKG_VERSION:=1.0.3
PKG_LICENSE:=NDM

PKG_SOURCE_URL:=$(NDM_STORAGE)/$(PKG_NAME)
PKG_SOURCE_VERSION:=$(PKG_VERSION)
PKG_SOURCE_PROTO:=git

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  SECTION:=libs
  CATEGORY:=Libraries
  TITLE:=Fatal signal crash logging library
  URL:=http://ndmsystems.com/
  DEPENDS:=+libpthread +libunwind
endef

EXTRA_CPPFLAGS := -DNDEBUG

EXTRA_CFLAGS   := $(FPIC) \
                  -Wall \
                  -pthread \
                  -shared \
                  -fasynchronous-unwind-tables \
                  -fno-omit-frame-pointer \
                  -fcaller-saves

EXTRA_LDFLAGS  := $(FPIC) -lpthread -lunwind

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/lib
	$(INSTALL_DIR) $(1)/usr/include
	$(CP) $(PKG_BUILD_DIR)/libfatalsig.so $(1)/usr/lib/
	$(CP) $(PKG_BUILD_DIR)/fatalsig.h $(1)/usr/include/
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_BUILD_DIR)/libfatalsig.so $(1)/usr/lib/
endef

$(eval $(call BuildPackage,$(PKG_NAME)))

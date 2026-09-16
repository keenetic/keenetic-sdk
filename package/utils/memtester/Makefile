#
# Copyright (C) 2006-2016 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=memtester
PKG_VERSION:=4.7.1-ndm-1
PKG_RELEASE:=1

PKG_SOURCE_URL:=$(NDM_STORAGE)/$(PKG_NAME)
PKG_SOURCE_VERSION:=$(PKG_VERSION)
PKG_SOURCE_PROTO:=git

PKG_MAINTAINER:=Charles Cazabon
PKG_LICENSE:=GPL-2.0+
PKG_LICENSE_FILES:=COPYING

include $(INCLUDE_DIR)/package.mk

define Package/memtester
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=Memory Test tools
  URL:=http://pyropus.ca/software/memtester/
endef

define Package/memtester/description
  A userspace utility for testing the memory subsystem for faults.
endef

EXTRA_CPPFLAGS := -D_LARGEFILE_SOURCE \
                  -D_LARGEFILE64_SOURCE \
                  -D_FILE_OFFSET_BITS=64 \
                  -DPOSIX \
                  -D_POSIX_C_SOURCE=200809L \
                  -DTEST_NARROW_WRITES

define Package/memtester/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(CP) $(PKG_BUILD_DIR)/memtester $(1)/usr/sbin/
endef

$(eval $(call BuildPackage,memtester))

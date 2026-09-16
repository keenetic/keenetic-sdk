include $(TOPDIR)/rules.mk

PKG_NAME:=exfatprogs
PKG_VERSION:=1.3.1
PKG_RELEASE:=1

PKG_LICENSE:=GPL-2.0
PKG_LICENSE_FILES:=COPYING

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://codeload.github.com/$(PKG_NAME)/$(PKG_NAME)/tar.gz/$(PKG_VERSION)?
PKG_HASH:=4ee16035376c51e13f48cb8aca7df840d333ead77cf2caf47c5edc25b2f61c0d

PKG_FIXUP:=autoreconf
PKG_INSTALL:=1

TARGET_CFLAGS += $(FPIC)

include $(INCLUDE_DIR)/package.mk

CONFIGURE_ARGS += \
	--enable-shared \
	--disable-static

define Package/exfatprogs/Default
  SECTION:=utils
  CATEGORY:=Utilities
  SUBMENU:=Filesystem
  URL:=https://github.com/exfatprogs/exfatprogs
endef

define Package/exfat-mkfs
  $(Package/exfatprogs/Default)
  TITLE:=Utility for creating an exFAT File System
endef

define Package/exfat-fsck
  $(Package/exfatprogs/Default)
  TITLE:=Utility for checking/repairing an exFAT File System
endef

define Package/exfat-mkfs/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/sbin/mkfs.exfat $(1)/usr/sbin/mkfs.exfat-fw
endef

define Package/exfat-fsck/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/sbin/fsck.exfat $(1)/usr/sbin/fsck.exfat-fw
endef

$(eval $(call BuildPackage,exfat-mkfs))
$(eval $(call BuildPackage,exfat-fsck))

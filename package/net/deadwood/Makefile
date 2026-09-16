include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/package-defaults.mk

PKG_NAME:=deadwood
PKG_VERSION:=3.5.0036-8

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=$(NDM_STORAGE)/MaraDNS
PKG_SOURCE_VERSION:=$(PKG_VERSION)

PKG_LICENSE:=BSD MIT
PKG_LICENSE_FILES:=COPYING

include $(INCLUDE_DIR)/package.mk

define Package/deadwood
  NAME:=$(PKG_NAME)
  SECTION:=net
  CATEGORY:=Network
  TITLE:=DNS recursive resolver
  URL:=http://maradns.org/deadwood
  DEPENDS:=+librt
endef

define Build/Prepare
	$(call Build/Prepare/Default)
	rm -rf $(PKG_BUILD_DIR)/configure
endef

define Build/Compile
	+$(MAKE) $(PKG_JOBS) -C $(PKG_BUILD_DIR)/deadwood-github/src \
		CC="$(TARGET_CC)" \
		CFLAGS="$(TARGET_CFLAGS)" \
		LDFLAGS="$(TARGET_LDFLAGS)" \
		STRIP="$(STRIP)"
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/deadwood-github/src/Deadwood \
		$(1)/usr/sbin/deadwood
endef

$(eval $(call BuildPackage,$(PKG_NAME)))

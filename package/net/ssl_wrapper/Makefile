include $(TOPDIR)/rules.mk

PKG_NAME:=ssl_wrapper
PKG_VERSION:=1.0.0
PKG_LICENSE:=GPL-2.0

PKG_SOURCE_URL:=$(NDM_STORAGE)/$(PKG_NAME)
PKG_SOURCE_VERSION:=$(PKG_VERSION)
PKG_SOURCE_PROTO:=git

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  NAME:=$(PKG_NAME)
  SECTION:=net
  CATEGORY:=Network
  TITLE:=TCP/SSL warpper
  DEPENDS:=+librt +libpthread +libopenssl +libndm
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/ssl_wrapper $(1)/usr/sbin
endef

$(eval $(call BuildPackage,$(PKG_NAME)))

# 
# Copyright (C) 2010 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=minidlna
PKG_VERSION:=1.3.0-6
PKG_LICENSE:=GPL-2.0

PKG_SOURCE_URL:=$(NDM_STORAGE)/$(PKG_NAME)
PKG_SOURCE_VERSION:=$(PKG_VERSION)
PKG_SOURCE_PROTO:=git

PKG_FIXUP:=autoreconf

include $(INCLUDE_DIR)/package.mk

define Package/minidlna
  SECTION:=multimedia
  CATEGORY:=Multimedia
  TITLE:=UPnP A/V & DLNA Media Server
  URL:=http://minidlna.sourceforge.net/
  DEPENDS:=+libpthread +libexif +libjpeg-turbo +libsqlite3 +libav +libid3tag +libndm
endef

define Package/minidlna/description
  MiniDLNA (aka ReadyDLNA) is server software with the aim of
  being fully compliant with DLNA/UPnP-AV clients.
endef

CONFIGURE_ARGS +=\
	--with-os-name="KeeneticOS" \
	--with-os-version="$(BSP_EPOCH).$(BSP_MAJOR)" \
	--with-os-url=$(CONFIG_TARGET_VENDOR_URL) \
	--with-manufacturer=$(CONFIG_TARGET_VENDOR) \
	--with-manufacturer-url=$(CONFIG_TARGET_VENDOR_URL) \
	--with-modelurl=$(CONFIG_TARGET_VENDOR_URL) \
	--with-db-path="/tmp/mnt/minidlna" \
	--with-log-path="/tmp/mnt/minidlna" \

define Package/minidlna/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/minidlnad $(1)/usr/bin/minidlna
endef

$(eval $(call BuildPackage,minidlna))

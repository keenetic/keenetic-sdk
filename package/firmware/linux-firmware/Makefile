 
#
# Copyright (C) 2014 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=linux-firmware
PKG_VERSION:=20211027
PKG_RELEASE:=1

PKG_SOURCE_URL:=@KERNEL/linux/kernel/firmware
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.xz
PKG_HASH:=bc2657dd8eb82386a9a7ec6df9ccf31c32c7e9073c05d37786c1edc273f9440a

PKG_LICENSE_FILES:=LICENCE.rtlwifi_firmware.txt

include $(INCLUDE_DIR)/package.mk

define Package/firmware-default
  SECTION:=firmware
  CATEGORY:=Firmware
  URL:=http://git.kernel.org/cgit/linux/kernel/git/firmware/linux-firmware.git
  TITLE:=$(1)
  DEPENDS:=$(2)
endef

define Build/Compile

endef

Package/r815x-firmware = $(call Package/firmware-default,RealTek RTL8152/3/6 firmware)
define Package/r815x-firmware/install
	$(INSTALL_DIR) $(1)/lib/firmware/rtl_nic
	$(CP) $(PKG_BUILD_DIR)/rtl_nic/rtl8153a-2.fw $(1)/lib/firmware/rtl_nic/rtl8153a-2.fw
	$(CP) $(PKG_BUILD_DIR)/rtl_nic/rtl8153a-3.fw $(1)/lib/firmware/rtl_nic/rtl8153a-3.fw
	$(CP) $(PKG_BUILD_DIR)/rtl_nic/rtl8153a-4.fw $(1)/lib/firmware/rtl_nic/rtl8153a-4.fw
	$(CP) $(PKG_BUILD_DIR)/rtl_nic/rtl8153a-4.fw $(1)/lib/firmware/rtl_nic/rtl8153a-4.fw
	$(CP) $(PKG_BUILD_DIR)/rtl_nic/rtl8153b-2.fw $(1)/lib/firmware/rtl_nic/rtl8153b-2.fw
	$(CP) $(PKG_BUILD_DIR)/rtl_nic/rtl8153c-1.fw $(1)/lib/firmware/rtl_nic/rtl8153c-1.fw
	$(CP) $(PKG_BUILD_DIR)/rtl_nic/rtl8156a-2.fw $(1)/lib/firmware/rtl_nic/rtl8156a-2.fw
	$(CP) $(PKG_BUILD_DIR)/rtl_nic/rtl8156b-2.fw $(1)/lib/firmware/rtl_nic/rtl8156b-2.fw
endef
$(eval $(call BuildPackage,r815x-firmware))

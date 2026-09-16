 
#
# Copyright (C) 2014 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=linux-firmware
PKG_VERSION:=20250613
PKG_RELEASE:=1

PKG_SOURCE_URL:=@KERNEL/linux/kernel/firmware
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.xz
PKG_HASH:=d40743337ca8bf9d2587e220ab30dec6a07b52cc5cb4a4ff8d92be14391a7fde

include $(INCLUDE_DIR)/package.mk

define Package/firmware-default
  SECTION:=firmware
  CATEGORY:=Firmware
  URL:=http://git.kernel.org/cgit/linux/kernel/git/firmware/linux-firmware.git
  TITLE:=$(1)
  DEPENDS:=$(2)
  LICENSE_FILES:=$(3)
endef

define Build/Compile

endef

Package/r815x-firmware = $(call Package/firmware-default,RealTek RTL8152/3/6 firmware,,LICENCE.rtlwifi_firmware.txt)

define Package/r815x-firmware/install
	$(INSTALL_DIR) $(1)/lib/firmware/rtl_nic
	$(CP) $(PKG_BUILD_DIR)/rtl_nic/rtl8153a-2.fw $(1)/lib/firmware/rtl_nic/rtl8153a-2.fw
	$(CP) $(PKG_BUILD_DIR)/rtl_nic/rtl8153a-3.fw $(1)/lib/firmware/rtl_nic/rtl8153a-3.fw
	$(CP) $(PKG_BUILD_DIR)/rtl_nic/rtl8153a-4.fw $(1)/lib/firmware/rtl_nic/rtl8153a-4.fw
	$(CP) $(PKG_BUILD_DIR)/rtl_nic/rtl8153b-2.fw $(1)/lib/firmware/rtl_nic/rtl8153b-2.fw
	$(CP) $(PKG_BUILD_DIR)/rtl_nic/rtl8153c-1.fw $(1)/lib/firmware/rtl_nic/rtl8153c-1.fw
	$(CP) $(PKG_BUILD_DIR)/rtl_nic/rtl8156a-2.fw $(1)/lib/firmware/rtl_nic/rtl8156a-2.fw
	$(CP) $(PKG_BUILD_DIR)/rtl_nic/rtl8156b-2.fw $(1)/lib/firmware/rtl_nic/rtl8156b-2.fw
endef

$(eval $(call BuildPackage,r815x-firmware))

Package/eip197-mini-firmware = $(call Package/firmware-default,Inside Secure EIP197 mini firmware,,LICENCE.inside-secure)

define Package/eip197-mini-firmware/install
	$(INSTALL_DIR) $(1)/lib/firmware/inside-secure/eip197_minifw
	$(INSTALL_DATA) \
		$(PKG_BUILD_DIR)/inside-secure/eip197_minifw/ifpp.bin \
		$(PKG_BUILD_DIR)/inside-secure/eip197_minifw/ipue.bin \
		$(1)/lib/firmware/inside-secure/eip197_minifw
endef

$(eval $(call BuildPackage,eip197-mini-firmware))

#
# Copyright (C) 2021 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=tzdata
PKG_VERSION:=2023c
PKG_HASH:=3f510b5d1b4ae9bb38e485aa302a776b317fb3637bdb6404c4adf7b6cadd965c
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=ftp://ftp.iana.org/tz/releases/
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)

TIMEZONE_LINK:=/etc/TZ
TIMEZONE_FILE:=/var/TZ

HOST_ZIC:=/usr/sbin/zic
ZONES:=Zones
ZONE_INFO:=/usr/share/zoneinfo

TZ_ROOT=$(1)$(ZONE_INFO)
TZ_DIR=$(TZ_ROOT)/posix
TZ_EXCLUDE:=

PKG_LICENSE:=FREE
PKG_LICENSE_FILES:=LICENSE

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  SECTION:=base
  CATEGORY:=Base system
  TITLE:=Timezone data files
  DEPENDS:=base-files
  URL:=https://www.iana.org/time-zones
endef

define Package/$(PKG_NAME)/description
    Timezone data files are used to take into
    account regional date and time settings.
endef

define Build/Prepare
	$(HOST_TAR) -xf $(DL_DIR)/$(PKG_SOURCE) -C $(PKG_BUILD_DIR)
endef

define Build/Compile
	# Create soft symlinks first to absent files.
	$(HOST_ZIC) -d $(PKG_BUILD_DIR)/$(ZONES) \
		$(PKG_BUILD_DIR)/backward 2> /dev/null
	# Generate timezone files for selected regions.
	$(HOST_ZIC) -d $(PKG_BUILD_DIR)/$(ZONES) \
		$(PKG_BUILD_DIR)/africa \
		$(PKG_BUILD_DIR)/asia \
		$(PKG_BUILD_DIR)/australasia \
		$(PKG_BUILD_DIR)/etcetera \
		$(PKG_BUILD_DIR)/europe \
		$(PKG_BUILD_DIR)/northamerica \
		$(PKG_BUILD_DIR)/southamerica
	# Remove timezone files from excluded regions and related symlinks.
	(cd $(PKG_BUILD_DIR)/$(ZONES); \
		rm -rf $(TZ_EXCLUDE); \
		for link in $$$$(find -type l); \
		do \
			if [ ! -e $$$$link ]; \
			then \
				rm $$$$link; \
			fi \
		done \
	)
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(TZ_DIR)
	$(INSTALL_DIR) $(1)/etc/
	$(CP) $(PKG_BUILD_DIR)/$(ZONES)/Africa $(TZ_DIR)
	$(CP) $(PKG_BUILD_DIR)/$(ZONES)/America $(TZ_DIR)
	$(CP) $(PKG_BUILD_DIR)/$(ZONES)/Antarctica $(TZ_DIR)
	$(CP) $(PKG_BUILD_DIR)/$(ZONES)/Arctic $(TZ_DIR)
	$(CP) $(PKG_BUILD_DIR)/$(ZONES)/Asia $(TZ_DIR)
	$(CP) $(PKG_BUILD_DIR)/$(ZONES)/Atlantic $(TZ_DIR)
	$(CP) $(PKG_BUILD_DIR)/$(ZONES)/Australia $(TZ_DIR)
	$(CP) $(PKG_BUILD_DIR)/$(ZONES)/Europe $(TZ_DIR)
	$(CP) $(PKG_BUILD_DIR)/$(ZONES)/Indian $(TZ_DIR)
	$(CP) $(PKG_BUILD_DIR)/$(ZONES)/Pacific $(TZ_DIR)
	$(CP) $(PKG_BUILD_DIR)/$(ZONES)/{CET,EET,GMT,MET,MST,WET} $(TZ_DIR)
	(cd $(PKG_BUILD_DIR)/$(ZONES); \
		for link in $$$$(find -type l); \
		do \
			$(CP) $$$$link $(TZ_DIR); \
		done; \
	); \
	(cd $(TZ_DIR); \
		for link in $$$$(find -type l); \
		do \
			if [ ! -e $$$$link ]; \
			then \
				rm $$$$link; \
			fi \
		done \
	)
ifneq ($(CONFIG_USE_MUSL)$(CONFIG_USE_UCLIBC),)
	tze -d $(TZ_DIR) > $(PKG_BUILD_DIR)/rules.txt
	rm -rf $(TZ_DIR)
	$(INSTALL_DIR) $(TZ_DIR)
	mv $(PKG_BUILD_DIR)/rules.txt $(TZ_DIR)
endif
	ln -sf $(TIMEZONE_FILE) $(1)$(TIMEZONE_LINK)
	$(CP) $(PKG_BUILD_DIR)/zone1970.tab $(TZ_ROOT)
endef

$(eval $(call BuildPackage,$(PKG_NAME)))

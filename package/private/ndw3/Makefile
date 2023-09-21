#
# Copyright (C) 2023 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=ndw3
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define Package/ndw3
  CATEGORY:=NDM
  TITLE:=Web interface wizard
  DEPENDS:=+libc +SSP_SUPPORT:libssp @!USES_NDW2_WIZARD +fonts-roboto
  DISABLE_RSTRIP:=y
endef

define Package/ndw3/install
	if [ -d ./files-ndw3 ]; then \
		$(CP) ./files-ndw3/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndw3))

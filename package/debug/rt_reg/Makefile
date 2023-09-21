#
# Copyright (C) 2023 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=rt_reg
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define Package/rt_reg
  CATEGORY:=Debug suite
  TITLE:=Ralink register control utility
  DEPENDS:=+libc +SSP_SUPPORT:libssp +kmod-rt_rdm
  DISABLE_RSTRIP:=y
endef

define Package/rt_reg/install
	if [ -d ./files-rt_reg ]; then \
		$(CP) ./files-rt_reg/* $(1); \
	fi
endef

$(eval $(call BuildPackage,rt_reg))

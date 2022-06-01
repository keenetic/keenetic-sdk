#
# Copyright (C) 2022 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=mimalloc
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define Package/mimalloc
  CATEGORY:=Libraries
  TITLE:=mimalloc general purpose allocator
  DEPENDS:=+libc +SSP_SUPPORT:libssp +librt +libatomic
  DISABLE_RSTRIP:=y
endef

define Package/mimalloc/install
	if [ -d ./files-mimalloc ]; then \
		$(CP) ./files-mimalloc/* $(1); \
	fi
endef

$(eval $(call BuildPackage,mimalloc))

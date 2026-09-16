#
# Copyright (C) 2026 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=idip-agent
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define Package/idip-agent
  CATEGORY:=Network
  TITLE:=Ivideon Bridge agent
  DEPENDS:=+libc +SSP_SUPPORT:libssp @!arm
  DISABLE_RSTRIP:=y
endef

define Package/idip-agent/install
	if [ -d ./files-idip-agent ]; then \
		$(CP) ./files-idip-agent/* $(1); \
	fi
endef

$(eval $(call BuildPackage,idip-agent))

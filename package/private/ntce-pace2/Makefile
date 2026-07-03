#
# Copyright (C) 2026 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=ntce-pace2
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define Package/ntce-pace2
  CATEGORY:=Network
  TITLE:=NDM PACE2 traffic classification engine daemon
  DEPENDS:=+libc +SSP_SUPPORT:libssp +libndm +pace2 +zlib +NTCE_PACE2_BACKTRACE:libfatalsig +NTCE_PACE2_MIMALLOC:libatomic +NTCE_PACE2_MIMALLOC:mimalloc +pace2-csc
  DISABLE_RSTRIP:=y
endef

define Package/ntce-pace2/config
if PACKAGE_ntce-pace2

config NTCE_PACE2_BACKTRACE
	bool "Log a backtrace on crash"

config NTCE_PACE2_MIMALLOC
	bool "Use mimalloc memory allocator"

endif
endef

define Package/ntce-pace2/install
	if [ -d ./files-ntce-pace2 ]; then \
		$(CP) ./files-ntce-pace2/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ntce-pace2))

define Package/ntce-pace2-flowstat
  CATEGORY:=Network
  TITLE:=PACE2 traffic classification engine flowstat utility
  DEPENDS:=+libc +SSP_SUPPORT:libssp +libndm +pace2 +zlib +NTCE_PACE2_BACKTRACE:libfatalsig +NTCE_PACE2_MIMALLOC:libatomic +NTCE_PACE2_MIMALLOC:mimalloc +libpcap
  DISABLE_RSTRIP:=y
endef

define Package/ntce-pace2-flowstat/install
	if [ -d ./files-ntce-pace2-flowstat ]; then \
		$(CP) ./files-ntce-pace2-flowstat/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ntce-pace2-flowstat))

#
# Copyright (C) 2022 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=valgrind
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define Package/valgrind
  CATEGORY:=Debug suite
  TITLE:=debugging and profiling tools for Linux
  DEPENDS:=+libc +SSP_SUPPORT:libssp @mips||mipsel||i386||x86_64||powerpc||arm_v7||aarch64 +libpthread +librt
  DISABLE_RSTRIP:=y
endef

define Package/valgrind/install
	if [ -d ./files-valgrind ]; then \
		$(CP) ./files-valgrind/* $(1); \
	fi
endef

$(eval $(call BuildPackage,valgrind))

define Package/valgrind-cachegrind
  CATEGORY:=Debug suite
  TITLE:=debugging and profiling tools for Linux (cache profiling)
  DEPENDS:=+libc +SSP_SUPPORT:libssp valgrind
  DISABLE_RSTRIP:=y
endef

define Package/valgrind-cachegrind/install
	if [ -d ./files-valgrind-cachegrind ]; then \
		$(CP) ./files-valgrind-cachegrind/* $(1); \
	fi
endef

$(eval $(call BuildPackage,valgrind-cachegrind))

define Package/valgrind-callgrind
  CATEGORY:=Debug suite
  TITLE:=debugging and profiling tools for Linux (callgraph profiling)
  DEPENDS:=+libc +SSP_SUPPORT:libssp valgrind
  DISABLE_RSTRIP:=y
endef

define Package/valgrind-callgrind/install
	if [ -d ./files-valgrind-callgrind ]; then \
		$(CP) ./files-valgrind-callgrind/* $(1); \
	fi
endef

$(eval $(call BuildPackage,valgrind-callgrind))

define Package/valgrind-drd
  CATEGORY:=Debug suite
  TITLE:=debugging and profiling tools for Linux (thread error detection)
  DEPENDS:=+libc +SSP_SUPPORT:libssp valgrind
  DISABLE_RSTRIP:=y
endef

define Package/valgrind-drd/install
	if [ -d ./files-valgrind-drd ]; then \
		$(CP) ./files-valgrind-drd/* $(1); \
	fi
endef

$(eval $(call BuildPackage,valgrind-drd))

define Package/valgrind-helgrind
  CATEGORY:=Debug suite
  TITLE:=debugging and profiling tools for Linux (thread debugging)
  DEPENDS:=+libc +SSP_SUPPORT:libssp valgrind
  DISABLE_RSTRIP:=y
endef

define Package/valgrind-helgrind/install
	if [ -d ./files-valgrind-helgrind ]; then \
		$(CP) ./files-valgrind-helgrind/* $(1); \
	fi
endef

$(eval $(call BuildPackage,valgrind-helgrind))

define Package/valgrind-massif
  CATEGORY:=Debug suite
  TITLE:=debugging and profiling tools for Linux (heap profiling)
  DEPENDS:=+libc +SSP_SUPPORT:libssp valgrind
  DISABLE_RSTRIP:=y
endef

define Package/valgrind-massif/install
	if [ -d ./files-valgrind-massif ]; then \
		$(CP) ./files-valgrind-massif/* $(1); \
	fi
endef

$(eval $(call BuildPackage,valgrind-massif))

define Package/valgrind-vgdb
  CATEGORY:=Debug suite
  TITLE:=debugging and profiling tools for Linux (GDB interface)
  DEPENDS:=+libc +SSP_SUPPORT:libssp valgrind
  DISABLE_RSTRIP:=y
endef

define Package/valgrind-vgdb/install
	if [ -d ./files-valgrind-vgdb ]; then \
		$(CP) ./files-valgrind-vgdb/* $(1); \
	fi
endef

$(eval $(call BuildPackage,valgrind-vgdb))

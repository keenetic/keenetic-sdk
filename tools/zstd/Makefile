#
# Copyright (C) 2021 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk

PKG_NAME:=zstd
PKG_VERSION:=1.5.0

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://github.com/facebook/zstd/releases/download/v$(PKG_VERSION)
PKG_HASH:=5194fbfa781fcf45b98c5e849651aa7b3b0a008c6b72d4a0db760f3002291e94

PKG_LICENSE:=BSD-3-Clause
PKG_LICENSE_FILES:=LICENSE

include $(INCLUDE_DIR)/host-build.mk

HOST_MAKE_FLAGS += \
	CC=$(HOSTCC_NOCACHE) \
	HAVE_LZ4=0 \
	HAVE_LZMA=0 \
	HAVE_ZLIB=0 \
	ZSTD_LEGACY_SUPPORT=0

define Host/Compile
	$(call Host/Compile/Default,zstd-release)
endef

define Host/Install
	$(INSTALL_DIR) $(STAGING_DIR_HOST)/bin
	$(INSTALL_BIN) $(HOST_BUILD_DIR)/programs/zstd $(STAGING_DIR_HOST)/bin
	$(LN) zstd $(STAGING_DIR_HOST)/bin/zstdcat
	$(LN) zstd $(STAGING_DIR_HOST)/bin/unzstd
endef

define Host/Clean
	rm -f $(STAGING_DIR_HOST)/bin/{zstd,zstdcat,unzstd}
endef

$(eval $(call HostBuild))

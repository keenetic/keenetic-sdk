#
# Copyright (C) 2021 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=gn
PKG_VERSION:=a4d67be044b42963de801001e7146f9657c7fad4

PKG_SOURCE_URL:=https://gn.googlesource.com/gn
PKG_SOURCE_VERSION:=$(PKG_VERSION)
PKG_SOURCE_PROTO:=git

PKG_LICENSE:=BSD
PKG_LICENSE_FILES:=LICENSE

HOST_BUILD_DEPENDS:=ninja/host
PKG_BUILD_DEPENDS:=ninja/host

include $(INCLUDE_DIR)/host-build.mk
include $(INCLUDE_DIR)/package.mk

define Host/Configure
endef

define Host/Compile
	cd $(HOST_BUILD_DIR) && \
		CXX="$(HOSTCXX)" \
		CXXFLAGS="$(HOST_CXXFLAGS) $(HOST_CPPFLAGS)" \
		LDFLAGS="$(HOST_LDFLAGS)" \
		./build/gen.py && \
		ninja -C out
endef

define Host/Install
	$(INSTALL_DIR) $(STAGING_DIR_HOST)/bin
	$(INSTALL_BIN) $(HOST_BUILD_DIR)/out/gn $(STAGING_DIR_HOST)/bin/
endef

define Host/Clean
	$(call Host/Clean/Default)
	rm -f $(STAGING_DIR_HOST)/bin/ninja
endef

define Package/gn
  SECTION:=devel
  CATEGORY:=Development
  TITLE:=gn
  URL:=https://gn.googlesource.com/gn/
endef

define Package/gn/description
  GN is a meta-build system that generates build files for Ninja.
endef

$(eval $(call HostBuild))
$(eval $(call BuildPackage,gn))

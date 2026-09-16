#
# Copyright (C) 2014 Qualcomm-Atheros Inc.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=sparse

PKG_VERSION:=0.6.0
PKG_HASH:=faad3d038e22024280bbd7d6093e9c22dc6333ab7db3638079b93036e43fc277
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.xz
PKG_SOURCE_URL:=@KERNEL/software/devel/sparse/dist/

include $(INCLUDE_DIR)/host-build.mk

define Host/Install
	$(INSTALL_BIN) $(HOST_BUILD_DIR)/sparse $(STAGING_DIR_HOST)/bin
endef

$(eval $(call HostBuild))

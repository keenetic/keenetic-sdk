include $(TOPDIR)/rules.mk

PKG_NAME:=dl

PKG_SOURCE:=$(notdir $(call qstrip,$(CONFIG_TOOLCHAIN_URL)))
PKG_SOURCE_URL:=$(patsubst %/,%,$(dir $(call qstrip,$(CONFIG_TOOLCHAIN_URL))))
PKG_HASH:=$(call qstrip,$(CONFIG_TOOLCHAIN_HASH))

include $(INCLUDE_DIR)/toolchain-build.mk
TAR_CMD=$(HOST_TAR) -C $(1) $(TAR_OPTIONS)

define Host/Configure
endef

define Host/Compile
endef

define Host/Install
endef

$(eval $(call HostBuild))

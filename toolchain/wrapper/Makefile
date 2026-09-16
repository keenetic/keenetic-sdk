#
# Copyright (C) 2012 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=wrapper
PKG_VERSION:=1

include $(INCLUDE_DIR)/toolchain-build.mk

ifneq ($(TOOLCHAIN_HONOUR_COPTS),)
  export GCC_HONOUR_COPTS=s
endif

# 1: args
define toolchain_util
$(strip $(SCRIPT_DIR)/ext-toolchain.sh --toolchain $(TOOLCHAIN_ROOT_DIR) \
	--cflags "$(if $(call qstrip,$(CONFIG_TOOLCHAIN_LIBC)),-m$(call qstrip,$(CONFIG_TOOLCHAIN_LIBC))) $(if $(CONFIG_SOFT_FLOAT),-msoft-float)" \
	--cflags "--sysroot $(TOOLCHAIN_SYSROOT_DIR)" \
	--bin-dirs $(patsubst ./%,%,$(CONFIG_TOOLCHAIN_BIN_PATH))
	$(1))
endef

# 1: config symbol
# 2: feature
define toolchain_test
$$(if $$($(1)), \
	@echo -n "Testing external toolchain for $(2) support ... "; \
	if $(call toolchain_util,--test "$(2)"); then \
		echo "ok"; exit 0; \
	else \
		echo "failed"; \
		echo "ERROR: $(1) is enabled but the external toolchain does not support it"; \
		exit 1; \
	fi)
endef

define toolchain_compiler_test
	@echo -n "Trying to compile simple program with $(1) compiler ... "; \
	if $(call toolchain_util,--test "$(2)"); then \
		echo "ok"; exit 0; \
	else \
		echo "failed"; \
		echo "Try to execute it manually"; \
		exit 1; \
	fi
endef

define Host/Prepare
	$(call toolchain_compiler_test,C,c)
	$(call toolchain_compiler_test,C++,c++)
	$(call toolchain_test,CONFIG_TOOLCHAIN_HONOUR_COPTS,honour_copts)
	$(call toolchain_test,CONFIG_SOFT_FLOAT,softfloat)
	$(call toolchain_test,CONFIG_IPV6,ipv6)
	$(call toolchain_test,CONFIG_NLS,wchar)
	$(call toolchain_test,CONFIG_PACKAGE_libpthread,threads)
endef

define Host/Configure
endef

define Host/Compile
endef

define Host/Install
	$(call toolchain_util,--wrap "$(TOOLCHAIN_DIR)/bin")
endef

define Host/Clean
	rm -rf $(TOOLCHAIN_DIR)/bin
endef

$(eval $(call HostBuild))

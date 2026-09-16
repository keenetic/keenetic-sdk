#
# Copyright (C) 2007-2012 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
PKG_NAME:=toolchain
PKG_RELEASE:=1

PKG_CONFIG_DEPENDS:=CONFIG_LIBC_UNSTRIPPED

include $(INCLUDE_DIR)/package.mk

ifneq ($(DUMP),1)
  LIBGCC_VERSION:=$(GCC_VERSION)
else
  LIBC_VERSION:=<LIBC_VERSION>
  LIBGCC_VERSION:=<LIBGCC_VERSION>
endif

define Package/gcc/Default
  SECTION:=libs
  CATEGORY:=Base system
  URL:=http://gcc.gnu.org/
  VERSION:=$(LIBGCC_VERSION)-$(PKG_RELEASE)
endef

define Package/libgcc
$(call Package/gcc/Default)
  TITLE:=GCC support library
endef

define Package/libgcc/config
	menu "Configuration"
		depends on EXTERNAL_TOOLCHAIN && PACKAGE_libgcc

	config LIBGCC_FILE_SPEC
		string
		prompt "libgcc shared library files (use wildcards)"
		depends on EXTERNAL_TOOLCHAIN && PACKAGE_libgcc
		default "./lib/libgcc_s.so.*"

	endmenu
endef

define Package/libatomic
$(call Package/gcc/Default)
  DEPENDS:=+libgcc
  TITLE:=Atomic support library
endef

define Package/libatomic/config
	menu "Configuration"
		depends on EXTERNAL_TOOLCHAIN && PACKAGE_libatomic

	config LIBATOMIC_FILE_SPEC
		string
		prompt "libatomic shared library files (use wildcards)"
		depends on EXTERNAL_TOOLCHAIN && PACKAGE_libatomic
		default "./lib/libatomic.so.*"

	endmenu
endef


define Package/libssp
$(call Package/gcc/Default)
  TITLE:=GCC support library
endef

define Package/libssp/config
	menu "Configuration"
		depends on EXTERNAL_TOOLCHAIN && PACKAGE_libssp

	config LIBSSP_FILE_SPEC
		string
		prompt "libssp shared library files (use wildcards)"
		depends on EXTERNAL_TOOLCHAIN && PACKAGE_libssp
		default "./lib/libssp.so.*"

	endmenu
endef


define Package/libstdcpp
$(call Package/gcc/Default)
  NAME:=libstdc++
  TITLE:=GNU Standard C++ Library v3
endef

define Package/libstdcpp/config
	menu "Configuration"
	depends on EXTERNAL_TOOLCHAIN && PACKAGE_libstdcpp

	config LIBSTDCPP_FILE_SPEC
		string
		prompt "libstdc++ shared library files (use wildcards)"
		depends on EXTERNAL_TOOLCHAIN && PACKAGE_libstdcpp
		default "./lib/libstdc++.so.*"

	endmenu
endef


define Package/libasan
$(call Package/gcc/Default)
  DEPENDS:=+libstdcpp
  TITLE:=GCC address sanitizer library
endef

define Package/libasan/config
	menu "Configuration"
		depends on EXTERNAL_TOOLCHAIN && PACKAGE_libasan

	config LIBASAN_FILE_SPEC
		string
		prompt "libasan shared library files (use wildcards)"
		depends on EXTERNAL_TOOLCHAIN && PACKAGE_libasan
		default "./lib/libasan.so.*"

	endmenu
endef


define Package/libtsan
$(call Package/gcc/Default)
  DEPENDS:=+libstdcpp
  TITLE:=GCC thread sanitizer library
endef

define Package/libtsan/config
	menu "Configuration"
		depends on aarch64 && EXTERNAL_TOOLCHAIN_LIBC_USE_GLIBC && PACKAGE_libtsan

	config LIBTSAN_FILE_SPEC
		string
		prompt "libtsan shared library files (use wildcards)"
		depends on aarch64 && EXTERNAL_TOOLCHAIN_LIBC_USE_GLIBC && PACKAGE_libtsan
		default "./lib/libtsan.so.*"

	endmenu
endef


define Package/libubsan
$(call Package/gcc/Default)
  DEPENDS:=+libstdcpp
  TITLE:=GCC undefined behavior sanitizer library
endef

define Package/libubsan/config
	menu "Configuration"
		depends on EXTERNAL_TOOLCHAIN && PACKAGE_libubsan

	config LIBUBSAN_FILE_SPEC
		string
		prompt "libubsan shared library files (use wildcards)"
		depends on EXTERNAL_TOOLCHAIN && PACKAGE_libubsan
		default "./lib/libubsan.so.*"

	endmenu
endef


define Package/libc/Default
  SECTION:=libs
  CATEGORY:=Base system
  VERSION:=$(LIBC_VERSION)-$(PKG_RELEASE)
  DEPENDS:=+libgcc
  URL:=$(LIBC_URL)
  PKG_FLAGS:=hold essential
endef

define Package/libc
$(call Package/libc/Default)
  TITLE:=C library
  DISABLE_RSTRIP:=$(CONFIG_LIBC_UNSTRIPPED)
endef

define Package/libc/config
	menu "Configuration"
	depends on EXTERNAL_TOOLCHAIN && PACKAGE_libc

	config LIBC_FILE_SPEC
		string
		prompt "libc shared library files (use wildcards)"
		depends on EXTERNAL_TOOLCHAIN && PACKAGE_libc
		default "./lib/ld{-*.so,-linux*.so.*} ./lib/lib{anl,c,cidn,crypt,dl,m,nsl,nss_dns,nss_files,resolv,util}{-*.so,.so.*}"

	config LIBC_UNSTRIPPED
		bool "Disable strip"

	endmenu
endef


define Package/libc-locales
$(call Package/libc/Default)
  TITLE:=C library locales
endef

define Package/libc-locales/config
	menu "Configuration"
		depends on EXTERNAL_TOOLCHAIN && PACKAGE_libc-locales

	config LIBC_LOCALES_FILE_SPEC
		string
		prompt "libc locale files (use wildcards)"
		depends on EXTERNAL_TOOLCHAIN && PACKAGE_libc-locales
		default "./usr/lib/locale/locale-archive" if USE_GLIBC

	endmenu
endef


define Package/libpthread
$(call Package/libc/Default)
  TITLE:=POSIX thread library
endef

define Package/libpthread/config
	menu "Configuration"
	depends on EXTERNAL_TOOLCHAIN && PACKAGE_libpthread

	config LIBPTHREAD_FILE_SPEC
		string
		prompt "libpthread shared library files (use wildcards)"
		depends on EXTERNAL_TOOLCHAIN && PACKAGE_libpthread
		default "./lib/libpthread{-*.so,.so.*}"

	endmenu
endef


define Package/libthread-db
$(call Package/libc/Default)
  TITLE:=POSIX thread debug library
endef

define Package/libthread-db/config
	menu "Configuration"
	depends on EXTERNAL_TOOLCHAIN && PACKAGE_libthread-db

	config LIBTHREAD_DB_FILE_SPEC
		string
		prompt "libthread-db shared library files (use wildcards)"
		depends on EXTERNAL_TOOLCHAIN && PACKAGE_libthread-db
		default "./lib/libthread_db{-*.so,.so.*}"

	endmenu
endef


define Package/librt
$(call Package/libc/Default)
  TITLE:=POSIX.1b RealTime extension library
  DEPENDS:=+libpthread
endef

define Package/librt/config
	menu "Configuration"
	depends on EXTERNAL_TOOLCHAIN && PACKAGE_librt

	config LIBRT_FILE_SPEC
		string
		prompt "librt shared library files (use wildcards)"
		depends on EXTERNAL_TOOLCHAIN && PACKAGE_librt
		default "./lib/librt{-*.so,.so.*}"

	endmenu
endef


define Package/libgfortran
$(call Package/gcc/Default)
  TITLE:=GFortran support library
  DEPENDS+=@INSTALL_GFORTRAN
endef

define Package/libgfortran/config
	menu "Configuration"
		depends on EXTERNAL_TOOLCHAIN && PACKAGE_libgfortran

	config LIBGFORTRAN_FILE_SPEC
		string
		prompt "libgfortran shared library files (use wildcards)"
		depends on EXTERNAL_TOOLCHAIN && PACKAGE_libgfortran
		default "./usr/lib/libgfortran.so.*"

	endmenu
endef


define Package/ldd
$(call Package/libc/Default)
  SECTION:=debug
  CATEGORY:=Debug suite
  TITLE:=LDD trace utility
endef

define Package/ldd/config
	menu "Configuration"
		depends on EXTERNAL_TOOLCHAIN && PACKAGE_ldd

	config LDD_FILE_SPEC
		string
		prompt "ldd trace utility file"
		depends on EXTERNAL_TOOLCHAIN && PACKAGE_ldd
		default "./usr/bin/ldd"

	endmenu
endef


define Package/ldconfig
$(call Package/libc/Default)
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=Shared library path configuration
endef

define Package/ldconfig/config
	menu "Configuration"
		depends on EXTERNAL_TOOLCHAIN && PACKAGE_ldconfig

	config LDCONFIG_FILE_SPEC
		string
		prompt "ldconfig file"
		depends on EXTERNAL_TOOLCHAIN && PACKAGE_ldconfig
		default "./sbin/ldconfig"

	endmenu
endef


define Package/ext-toolchain-gdb
$(call Package/libc/Default)
  SECTION:=debug
  CATEGORY:=Debug suite
  TITLE:=GNU Debugger (external)
  DEPENDS:=+libthread-db
  URL:=http://www.gnu.org/software/gdb/
endef

define Package/ext-toolchain-gdb/config
	menu "Configuration"
		depends on EXTERNAL_TOOLCHAIN && PACKAGE_ext-toolchain-gdb

	config EXT_TOOLCHAIN_GDB_FILE_SPEC
		string
		prompt "gdb file"
		depends on EXTERNAL_TOOLCHAIN && PACKAGE_ext-toolchain-gdb
		default "./usr/bin/gdb"

	endmenu
endef


define Package/ext-toolchain-gdbserver
$(call Package/libc/Default)
  SECTION:=debug
  CATEGORY:=Debug suite
  TITLE:=Remote server for GNU Debugger (external)
  DEPENDS:=+libthread-db
  URL:=http://www.gnu.org/software/gdb/
endef

define Package/ext-toolchain-gdbserver/config
	menu "Configuration"
		depends on EXTERNAL_TOOLCHAIN && PACKAGE_ext-toolchain-gdb

	config EXT_TOOLCHAIN_GDBSERVER_FILE_SPEC
		string
		prompt "gdbserver file"
		depends on EXTERNAL_TOOLCHAIN && PACKAGE_ext-toolchain-gdbserver
		default "./usr/bin/gdbserver"

	endmenu
endef


define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

LIBGCC_A=$(wildcard $(TOOLCHAIN_DIR)/lib/gcc/*/*/libgcc_pic.a)
LIBGCC_MAP=$(wildcard $(TOOLCHAIN_DIR)/lib/gcc/*/*/libgcc.map)
LIBGCC_SO=$(wildcard $(TOOLCHAIN_DIR)/lib/libgcc_s.so.*)
LIBUCLIBC_SO=$(wildcard $(TOOLCHAIN_DIR)/lib/libuClibc-*.so)
ifeq ($(CONFIG_EXTERNAL_TOOLCHAIN),)
  ifneq ($(if $(CONFIG_USE_UCLIBC),$(CONFIG_GCC_VERSION_LINARO)),)
    BUILD_LIBGCC:=$(if $(CONFIG_m68k)$(CONFIG_powerpc),,$(PKG_BUILD_DIR)/libgcc_s.so.*)
  endif
else
  ifeq ($(CONFIG_TOOLCHAIN_LIBC),"glibc")
    USE_NSSWITCH:=y
  endif
endif

ifneq ($(BUILD_LIBGCC),)
  define Build/Compile/uClibc
	$(SCRIPT_DIR)/relink-lib.sh \
		"$(TARGET_CROSS)" \
		"$(wildcard $(TOOLCHAIN_DIR)/lib/libc_so.a)" \
		"$(wildcard $(TOOLCHAIN_DIR)/lib/libc_so.a)" \
		"$(patsubst $(TOOLCHAIN_DIR)/lib/%,$(PKG_BUILD_DIR)/%,$(wildcard $(TOOLCHAIN_DIR)/lib/libuClibc-*.so))" \
		-Wl,-init,__uClibc_init -Wl,-soname=libc.so.0 \
		$(BUILD_LIBGCC)
	$(SCRIPT_DIR)/relink-lib.sh \
		"$(TARGET_CROSS)" \
		"$(wildcard $(TOOLCHAIN_DIR)/lib/libcrypt-*.so)" \
		"$(wildcard $(TOOLCHAIN_DIR)/lib/libcrypt_pic.a)" \
		"$(patsubst $(TOOLCHAIN_DIR)/lib/%,$(PKG_BUILD_DIR)/%,$(wildcard $(TOOLCHAIN_DIR)/lib/libcrypt-*.so))" \
		$(BUILD_LIBGCC) \
		-Wl,-soname=libcrypt.so.0
	$(SCRIPT_DIR)/relink-lib.sh \
		"$(TARGET_CROSS)" \
		"$(wildcard $(TOOLCHAIN_DIR)/lib/libm-*.so)" \
		"$(wildcard $(TOOLCHAIN_DIR)/lib/libm_pic.a)" \
		"$(patsubst $(TOOLCHAIN_DIR)/lib/%,$(PKG_BUILD_DIR)/%,$(wildcard $(TOOLCHAIN_DIR)/lib/libm-*.so))" \
		$(BUILD_LIBGCC) \
		-Wl,-soname=libm.so.0
	$(SCRIPT_DIR)/relink-lib.sh \
		"$(TARGET_CROSS)" \
		"$(wildcard $(TOOLCHAIN_DIR)/lib/libpthread-*.so)" \
		"$(wildcard $(TOOLCHAIN_DIR)/lib/libpthread_so.a)" \
		"$(patsubst $(TOOLCHAIN_DIR)/lib/%,$(PKG_BUILD_DIR)/%,$(wildcard $(TOOLCHAIN_DIR)/lib/libpthread-*.so))" \
		-Wl,-z,nodelete,-z,initfirst,-init=__pthread_initialize_minimal_internal \
		-ldl -lc $(BUILD_LIBGCC) \
		-Wl,-soname=libpthread.so.0
  endef
  define Build/Compile/libgcc
	$(SCRIPT_DIR)/relink-lib.sh \
		"$(TARGET_CROSS)" \
		"$(LIBGCC_SO)" \
		"$(LIBGCC_A)" \
		"$(patsubst $(TOOLCHAIN_DIR)/lib/%,$(PKG_BUILD_DIR)/%,$(LIBGCC_SO))" \
		-Wl,--version-script=$(LIBGCC_MAP) -Wl,-soname=libgcc_s.so.1
  endef
else
  ifneq ($(LIBUCLIBC_SO),)
    define Build/Compile/uClibc
	$(CP) \
		$(TOOLCHAIN_DIR)/lib/libuClibc-*.so \
		$(TOOLCHAIN_DIR)/lib/libcrypt-*.so \
		$(TOOLCHAIN_DIR)/lib/libm-*.so \
		$(TOOLCHAIN_DIR)/lib/libpthread-*.so \
		$(PKG_BUILD_DIR)/
    endef
  endif
  ifneq ($(LIBGCC_SO),)
    define Build/Compile/libgcc
	$(CP) $(LIBGCC_SO) $(PKG_BUILD_DIR)/
    endef
  endif
endif

define Build/Compile/Default
	$(call Build/Compile/libgcc)
	$(call Build/Compile/$(LIBC))
endef
Build/Compile = $(Build/Compile/Default)

ifeq ($(CONFIG_EXTERNAL_TOOLCHAIN),)

  define Package/libgcc/install
	$(INSTALL_DIR) $(1)/lib
	$(CP) $(TOOLCHAIN_DIR)/lib/libgcc_s.so.* $(1)/lib/
  endef

  define Package/libatomic/install
	$(INSTALL_DIR) $(1)/lib
	$(CP) $(TOOLCHAIN_DIR)/lib/libatomic.so.* $(1)/lib/
  endef

  define Package/libgfortran/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(TOOLCHAIN_DIR)/lib/libgfortran.so.* $(1)/usr/lib/
  endef

  define Package/libssp/install
	$(INSTALL_DIR) $(1)/lib
	$(CP) $(TOOLCHAIN_DIR)/lib/libssp.so.* $(1)/lib/
  endef

  define Package/libstdcpp/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(TOOLCHAIN_DIR)/lib/libstdc++.so.* $(1)/usr/lib/
  endef

  define Package/libasan/install
	$(INSTALL_DIR) $(1)/lib
	$(CP) $(TOOLCHAIN_DIR)/lib/libasan.so.* $(1)/lib/
  endef

  define Package/libubsan/install
	$(INSTALL_DIR) $(1)/lib
	$(CP) $(TOOLCHAIN_DIR)/lib/libubsan.so.* $(1)/lib/
  endef

  define Package/glibc/install
	$(CP) ./glibc-files/* $(1)/
	rm -f $(1)/etc/localtime
	ln -sf /tmp/localtime $(1)/etc/localtime
	$(INSTALL_DIR) $(1)/lib
	$(CP) \
		$(TOOLCHAIN_DIR)/lib/ld*.so.* \
		$(TOOLCHAIN_DIR)/lib/ld-$(LIBC_SO_VERSION).so \
		$(1)/lib/
	for file in libanl libc libcidn libcrypt libdl libm libnsl libnss_dns libnss_files libresolv libutil; do \
		for file in $(TOOLCHAIN_DIR)/lib/$$$$file.so.* $(TOOLCHAIN_DIR)/lib/$$$$file-$(LIBC_SO_VERSION).so; do \
			if [ -e "$$$$file" ]; then \
				$(CP) $$$$file $(1)/lib/; \
			fi; \
		done; \
	done
  endef

  define Package/uClibc/install
	$(INSTALL_DIR) $(1)/lib
	$(CP) \
		$(TOOLCHAIN_DIR)/lib/ld*-uClibc.so.* \
		$(TOOLCHAIN_DIR)/lib/ld*-uClibc-$(LIBC_SO_VERSION).so \
		$(1)/lib/
	$(CP) \
		$(TOOLCHAIN_DIR)/lib/libc.so.* \
		$(TOOLCHAIN_DIR)/lib/libuClibc-$(LIBC_SO_VERSION).so \
		$(1)/lib/
	for file in libcrypt libdl libm libutil; do \
		$(CP) \
			$(TOOLCHAIN_DIR)/lib/$$$$file.so.* \
			$(TOOLCHAIN_DIR)/lib/$$$$file-$(LIBC_SO_VERSION).so \
			$(1)/lib/; \
	done

	$(CP) \
		$(PKG_BUILD_DIR)/libuClibc-* \
		$(PKG_BUILD_DIR)/libm-* \
		$(PKG_BUILD_DIR)/libcrypt-* \
		$(1)/lib/
  endef

  define Package/libc/install
    $(call Package/$(LIBC)/install,$1)
  endef

  define Package/libc/install_lib
	$(CP) $(filter-out %/libdl_pic.a %/libpthread_pic.a %/libresolv_pic.a,$(wildcard $(TOOLCHAIN_DIR)/lib/lib*.a)) $(1)/lib/
	$(if $(wildcard $(TOOLCHAIN_DIR)/lib/libc_so.a),$(CP) $(TOOLCHAIN_DIR)/lib/libc_so.a $(1)/lib/libc_pic.a)
	$(if $(LIBGCC_MAP), \
		$(CP) $(LIBGCC_A) $(1)/lib/libgcc_s_pic.a; \
		$(CP) $(LIBGCC_MAP) $(1)/lib/libgcc_s_pic.map \
	)
  endef

  define Package/libpthread/install
	$(INSTALL_DIR) $(1)/lib
	$(CP) \
		$(TOOLCHAIN_DIR)/lib/libpthread.so.* \
		$(if $(BUILD_LIBGCC),\
			$(PKG_BUILD_DIR)/libpthread-$(LIBC_SO_VERSION).so, \
			$(TOOLCHAIN_DIR)/lib/libpthread-$(LIBC_SO_VERSION).so \
		) \
		$(1)/lib/
  endef

  define Package/libthread-db/install
	$(INSTALL_DIR) $(1)/lib
	$(CP) \
		$(TOOLCHAIN_DIR)/lib/libthread_db.so.* $(1)/lib
  ifeq ($(USE_UCLIBC),y)
	$(CP) \
		$(TOOLCHAIN_DIR)/lib/libthread_db-$(LIBC_SO_VERSION).so \
		$(1)/lib/
  endif
  endef

  define Package/libpthread/install_lib
	$(if $(wildcard $(TOOLCHAIN_DIR)/lib/libpthread_so.a),$(CP) $(TOOLCHAIN_DIR)/lib/libpthread_so.a $(1)/lib/libpthread_pic.a)
  endef

  define Package/librt/install
	$(INSTALL_DIR) $(1)/lib
	$(CP) \
		$(TOOLCHAIN_DIR)/lib/librt.so.* \
		$(TOOLCHAIN_DIR)/lib/librt-$(LIBC_SO_VERSION).so \
		$(1)/lib/
  endef

  define Package/ldd/install
	$(INSTALL_DIR) $(1)/usr/bin/
	$(CP) $(TOOLCHAIN_DIR)/bin/ldd $(1)/usr/bin/
  endef

  define Package/ldconfig/install
	$(INSTALL_DIR) $(1)/sbin/
	$(CP) $(TOOLCHAIN_DIR)/sbin/ldconfig $(1)/sbin/
  endef

else

  define Package/libgcc/install
	for file in $(call qstrip,$(CONFIG_LIBGCC_FILE_SPEC)); do \
		dir=`dirname $$$$file` ; \
		$(INSTALL_DIR) $(1)/$$$$dir ; \
		$(CP) $(call qstrip,$(TOOLCHAIN_SYSROOT_DIR))/$$$$file $(1)/$$$$dir/ ; \
	done ; \
	exit 0
  endef

  define Package/libgfortran/install
	for file in $(call qstrip,$(CONFIG_LIBGFORTRAN_FILE_SPEC)); do \
		dir=`dirname $$$$file` ; \
		$(INSTALL_DIR) $(1)/$$$$dir ; \
		$(CP) $(call qstrip,$(TOOLCHAIN_SYSROOT_DIR))/$$$$file $(1)/$$$$dir/ ; \
	done
  endef

  define Package/libssp/install
	for file in $(call qstrip,$(CONFIG_LIBSSP_FILE_SPEC)); do \
		dir=`dirname $$$$file` ; \
		$(INSTALL_DIR) $(1)/$$$$dir ; \
		$(CP) $(call qstrip,$(TOOLCHAIN_SYSROOT_DIR))/$$$$file $(1)/$$$$dir/ ; \
	done ; \
	exit 0
  endef

  define Package/libstdcpp/install
	for file in $(call qstrip,$(CONFIG_LIBSTDCPP_FILE_SPEC)); do \
		dir=`dirname $$$$file` ; \
		$(INSTALL_DIR) $(1)/$$$$dir ; \
		$(CP) $(call qstrip,$(TOOLCHAIN_SYSROOT_DIR))/$$$$file $(1)/$$$$dir/ ; \
	done ; \
	exit 0
  endef

  define Package/libc/install
	$(if $(USE_NSSWITCH),$(CP) ./glibc-files/* $(1)/)
	sysroot_dir=$(call qstrip,$(TOOLCHAIN_SYSROOT_DIR)) ; \
	for spec in $(call qstrip,$(CONFIG_LIBC_FILE_SPEC)); do \
		files=`ls $$$$sysroot_dir$$$$spec 2>/dev/null` ; \
		for file in $$$$files; do \
			rootfs_file=$$$${file#"$$$$sysroot_dir"} ; \
			dir=`dirname $$$$rootfs_file` ; \
			name=`basename $$$$rootfs_file` ; \
			$(INSTALL_DIR) $(1)/$$$$dir ; \
			$(CP) $$$$file $(1)/$$$$dir/ ; \
			$(TARGET_STRIP) --strip-debug --keep-section=.debug_frame $(1)/$$$$dir/$$$$name ; \
		done ; \
	done ; \
	exit 0
  endef

  define Package/libc/install_lib
	$(INSTALL_DIR) $(1)/lib
	$(if $(wildcard $(TOOLCHAIN_ROOT_DIR)/lib/gcc/*/*/libgcc_pic.a), \
		$(CP) \
			$(TOOLCHAIN_ROOT_DIR)/lib/gcc/*/*/libgcc_pic.a \
			$(1)/lib/libgcc_s_pic.a \
	)
	$(if $(wildcard $(TOOLCHAIN_ROOT_DIR)/lib/gcc/*/*/libgcc.map), \
		$(CP) \
			$(TOOLCHAIN_ROOT_DIR)/lib/gcc/*/*/libgcc.map \
			$(1)/lib/libgcc_s_pic.map \
	)
	$(if $(wildcard $(TOOLCHAIN_SYSROOT_DIR)/usr/lib/libc_pic.a), \
		$(CP) \
			$(TOOLCHAIN_SYSROOT_DIR)/usr/lib/libc_pic.a \
			$(1)/lib/libc_pic.a \
	)
	$(if $(wildcard $(TOOLCHAIN_SYSROOT_DIR)/usr/lib/libc_so.a), \
		$(CP) \
			--remove-destination \
			$(TOOLCHAIN_SYSROOT_DIR)/usr/lib/libc_so.a \
			$(1)/lib/libc_pic.a \
	)
	$(if $(wildcard $(TOOLCHAIN_SYSROOT_DIR)/usr/lib/uclibc_nonshared.a), \
		$(CP) \
			$(TOOLCHAIN_SYSROOT_DIR)/usr/lib/uclibc_nonshared.a \
			$(1)/lib/ \
	)
  endef

  define Package/libc-locales/install
	for file in $(call qstrip,$(CONFIG_LIBC_LOCALES_FILE_SPEC)); do \
		dir=`dirname $$$$file` ; \
		$(INSTALL_DIR) $(1)/$$$$dir ; \
		$(CP) $(call qstrip,$(TOOLCHAIN_SYSROOT_DIR))/$$$$file $(1)/$$$$dir/ ; \
	done ; \
	exit 0
  endef

  define Package/libasan/install
	for file in $(call qstrip,$(CONFIG_LIBASAN_FILE_SPEC)); do \
		dir=`dirname $$$$file` ; \
		$(INSTALL_DIR) $(1)/$$$$dir ; \
		$(CP) $(call qstrip,$(TOOLCHAIN_SYSROOT_DIR))/$$$$file $(1)/$$$$dir/ ; \
	done ; \
	exit 0
  endef

  define Package/libtsan/install
	for file in $(call qstrip,$(CONFIG_LIBTSAN_FILE_SPEC)); do \
		dir=`dirname $$$$file` ; \
		$(INSTALL_DIR) $(1)/$$$$dir ; \
		$(CP) $(call qstrip,$(TOOLCHAIN_SYSROOT_DIR))/$$$$file $(1)/$$$$dir/ ; \
	done ; \
	exit 0
  endef

  define Package/libubsan/install
	for file in $(call qstrip,$(CONFIG_LIBUBSAN_FILE_SPEC)); do \
		dir=`dirname $$$$file` ; \
		$(INSTALL_DIR) $(1)/$$$$dir ; \
		$(CP) $(call qstrip,$(TOOLCHAIN_SYSROOT_DIR))/$$$$file $(1)/$$$$dir/ ; \
	done ; \
	exit 0
  endef

  define Package/libpthread/install
	for file in $(call qstrip,$(CONFIG_LIBPTHREAD_FILE_SPEC)); do \
		dir=`dirname $$$$file` ; \
		$(INSTALL_DIR) $(1)/$$$$dir ; \
		$(CP) $(call qstrip,$(TOOLCHAIN_SYSROOT_DIR))/$$$$file $(1)/$$$$dir/ ; \
	done ; \
	exit 0
  endef

  define Package/libpthread/install_lib
	$(if $(wildcard $(TOOLCHAIN_SYSROOT_DIR)/usr/lib/libpthread_nonshared.a), \
		$(CP) \
			$(TOOLCHAIN_SYSROOT_DIR)/usr/lib/libpthread_nonshared.a \
			$(1)/lib/ \
	)
  endef

  define Package/libthread-db/install
	for file in $(call qstrip,$(CONFIG_LIBTHREAD_DB_FILE_SPEC)); do \
		dir=`dirname $$$$file` ; \
		$(INSTALL_DIR) $(1)/$$$$dir ; \
		$(CP) $(call qstrip,$(TOOLCHAIN_SYSROOT_DIR))/$$$$file $(1)/$$$$dir/ ; \
	done ; \
	exit 0
  endef

  define Package/librt/install
	for file in $(call qstrip,$(CONFIG_LIBRT_FILE_SPEC)); do \
		dir=`dirname $$$$file` ; \
		$(INSTALL_DIR) $(1)/$$$$dir ; \
		$(CP) $(call qstrip,$(TOOLCHAIN_SYSROOT_DIR))/$$$$file $(1)/$$$$dir/ ; \
	done ; \
	exit 0
  endef

  define Package/libatomic/install
	for file in $(call qstrip,$(CONFIG_LIBATOMIC_FILE_SPEC)); do \
		dir=`dirname $$$$file` ; \
		$(INSTALL_DIR) $(1)/$$$$dir ; \
		$(CP) $(call qstrip,$(TOOLCHAIN_SYSROOT_DIR))/$$$$file $(1)/$$$$dir/ ; \
	done ; \
	exit 0
  endef

  define Package/ldd/install
	for file in $(call qstrip,$(CONFIG_LDD_FILE_SPEC)); do \
		dir=`dirname $$$$file` ; \
		$(INSTALL_DIR) $(1)/$$$$dir ; \
		$(CP) $(call qstrip,$(TOOLCHAIN_SYSROOT_DIR))/$$$$file $(1)/$$$$dir/ ; \
	done ; \
	exit 0
  endef

  define Package/ldconfig/install
	for file in $(call qstrip,$(CONFIG_LDCONFIG_FILE_SPEC)); do \
		dir=`dirname $$$$file` ; \
		$(INSTALL_DIR) $(1)/$$$$dir ; \
		$(CP) $(call qstrip,$(TOOLCHAIN_SYSROOT_DIR))/$$$$file $(1)/$$$$dir/ ; \
	done ; \
	exit 0
  endef

  define Package/ext-toolchain-gdb/install
	for file in $(call qstrip,$(CONFIG_EXT_TOOLCHAIN_GDB_FILE_SPEC)); do \
		dir=`dirname $$$$file` ; \
		$(INSTALL_DIR) $(1)/$$$$dir ; \
		$(CP) $(call qstrip,$(TOOLCHAIN_DEBUGROOT_DIR))/$$$$file $(1)/$$$$dir/ ; \
	done ; \
	exit 0
  endef

  define Package/ext-toolchain-gdbserver/install
	for file in $(call qstrip,$(CONFIG_EXT_TOOLCHAIN_GDBSERVER_FILE_SPEC)); do \
		dir=`dirname $$$$file` ; \
		$(INSTALL_DIR) $(1)/$$$$dir ; \
		$(CP) $(call qstrip,$(TOOLCHAIN_DEBUGROOT_DIR))/$$$$file $(1)/$$$$dir/ ; \
	done ; \
	exit 0
  endef

endif

$(eval $(call BuildPackage,libc))
$(eval $(call BuildPackage,libc-locales))
$(eval $(call BuildPackage,libgcc))
$(eval $(call BuildPackage,libatomic))
$(eval $(call BuildPackage,libssp))
$(eval $(call BuildPackage,libstdcpp))
$(eval $(call BuildPackage,libasan))
$(eval $(call BuildPackage,libtsan))
$(eval $(call BuildPackage,libubsan))
$(eval $(call BuildPackage,libpthread))
$(eval $(call BuildPackage,libthread-db))
$(eval $(call BuildPackage,librt))
$(eval $(call BuildPackage,libgfortran))
$(eval $(call BuildPackage,ldd))
$(eval $(call BuildPackage,ldconfig))
$(eval $(call BuildPackage,ext-toolchain-gdb))
$(eval $(call BuildPackage,ext-toolchain-gdbserver))

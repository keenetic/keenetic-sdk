#
# Copyright (C) 2006-2007 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(INCLUDE_DIR)/host.mk
include $(INCLUDE_DIR)/prereq.mk

ifneq ($(DUMP),1)
  all: compile
endif

export QUILT=1
NDM_PRELOADER_HEADER:=$(LINUX_DIR)/drivers/mtd/ndm_preloader.h
NDM_ATF_HEADER:=$(LINUX_DIR)/drivers/mtd/ndm_atf.h
NDM_BOOT_HEADER:=$(LINUX_DIR)/drivers/mtd/ndm_boot.h
STAMP_PREPARED:=$(LINUX_DIR)/.prepared
STAMP_CONFIGURED:=$(LINUX_DIR)/.configured
include $(INCLUDE_DIR)/download.mk
include $(INCLUDE_DIR)/quilt.mk
include $(INCLUDE_DIR)/kernel-defaults.mk

define Kernel/Prepare
	$(call Kernel/Prepare/Default)
endef

define Kernel/Configure
	$(call Kernel/Configure/Default)
endef

define Kernel/CompileModules
	$(call Kernel/CompileModules/Default)
endef

define Kernel/CompileImage
	$(call Kernel/CompileImage/Default)
endef

define Kernel/Clean
	$(call Kernel/Clean/Default)
endef

KERNEL_SOURCE_PROTO:=git
KERNEL_SOURCE_URL:=$(KERNEL_GIT_CLONE_URI)
KERNEL_SOURCE_FILE:=linux-$(KERNEL_GIT_REVISION).tar.zst

define Download/kernel
  PROTO:=$(KERNEL_SOURCE_PROTO)
  URL:=$(KERNEL_SOURCE_URL)
  VERSION:=$(KERNEL_GIT_REVISION)
  SUBDIR:=linux-$(LINUX_VERSION)
  FILE:=linux-$(KERNEL_GIT_REVISION).tar.zst
  DL_FILE:=$(KERNEL_SOURCE_FILE)
  MD5SUM:=$(LINUX_KERNEL_MD5SUM)
endef

ifdef CONFIG_COLLECT_KERNEL_DEBUG
  define Kernel/CollectDebug
	rm -rf $(KERNEL_BUILD_DIR)/debug
	mkdir -p $(KERNEL_BUILD_DIR)/debug/modules
	$(CP) $(LINUX_DIR)/vmlinux $(KERNEL_BUILD_DIR)/debug/
	-$(CP) \
		$(STAGING_DIR_ROOT)/lib/modules/$(LINUX_VERSION)/* \
		$(KERNEL_BUILD_DIR)/debug/modules/
	$(FIND) $(KERNEL_BUILD_DIR)/debug -type f | $(XARGS) $(KERNEL_CROSS)strip --only-keep-debug
	$(TAR) c -C $(KERNEL_BUILD_DIR) debug | gzip -c -9 > $(BIN_DIR)/kernel-debug.tar.gz
  endef
endif

define BuildKernel
  $(if $(QUILT),$(Build/Quilt))
  $(call Download,kernel)

  $(STAMP_PREPARED): $(DL_DIR)/linux-$(KERNEL_GIT_REVISION).tar.zst
	-rm -rf $(KERNEL_BUILD_DIR)
	-mkdir -p $(KERNEL_BUILD_DIR)
	$(Kernel/Prepare)
	touch $$@

  $(KERNEL_BUILD_DIR)/symtab.h: $(if $(CONFIG_KERNEL_MTD_NDM_PRELOADER_UPDATE),$(NDM_PRELOADER_HEADER)) $(if $(CONFIG_KERNEL_MTD_NDM_ATF_UPDATE),$(NDM_ATF_HEADER)) $(if $(CONFIG_KERNEL_MTD_NDM_BOOT_UPDATE),$(NDM_BOOT_HEADER)) FORCE
	rm -f $(KERNEL_BUILD_DIR)/symtab.h
	touch $(KERNEL_BUILD_DIR)/symtab.h
	+$(KERNEL_MAKE) vmlinux
	find $(LINUX_DIR) $(STAGING_DIR_ROOT)/lib/modules -name \*.ko | \
		xargs $(TARGET_CROSS)nm | \
		awk '$$$$1 == "U" { print $$$$2 } ' | \
		sort -u > $(KERNEL_BUILD_DIR)/mod_symtab.txt
	$(TARGET_CROSS)nm -n $(LINUX_DIR)/vmlinux.o | grep ' [rR] __ksymtab' | sed -e 's|.\{8,16\} [rR] __ksymtab_||' > $(KERNEL_BUILD_DIR)/kernel_symtab.txt
	grep -Ff $(KERNEL_BUILD_DIR)/mod_symtab.txt $(KERNEL_BUILD_DIR)/kernel_symtab.txt > $(KERNEL_BUILD_DIR)/sym_include.txt
	grep -Fvf $(KERNEL_BUILD_DIR)/mod_symtab.txt $(KERNEL_BUILD_DIR)/kernel_symtab.txt > $(KERNEL_BUILD_DIR)/sym_exclude.txt
	( \
		echo '#define SYMTAB_KEEP \'; \
		cat $(KERNEL_BUILD_DIR)/sym_include.txt | \
			awk '{print "KEEP(*(___ksymtab+" $$$$1 ")) \\" }'; \
		echo; \
		echo '#define SYMTAB_KEEP_GPL \'; \
		cat $(KERNEL_BUILD_DIR)/sym_include.txt | \
			awk '{print "KEEP(*(___ksymtab_gpl+" $$$$1 ")) \\" }'; \
		echo; \
		echo '#define SYMTAB_DISCARD \'; \
		cat $(KERNEL_BUILD_DIR)/sym_exclude.txt | \
			awk '{print "*(___ksymtab+" $$$$1 ") \\" }'; \
		echo; \
		echo '#define SYMTAB_DISCARD_GPL \'; \
		cat $(KERNEL_BUILD_DIR)/sym_exclude.txt | \
			awk '{print "*(___ksymtab_gpl+" $$$$1 ") \\" }'; \
		echo; \
	) > $$@

  $(NDM_PRELOADER_HEADER): $(PLATFORM_SUBDIR)/preloader.bin
	$(SCRIPT_DIR)/ndm_bin_gen_header.sh $$< $$@

  $(NDM_ATF_HEADER): $(PLATFORM_SUBDIR)/atf.bin
	$(SCRIPT_DIR)/ndm_bin_gen_header.sh $$< $$@

  $(NDM_BOOT_HEADER): $(PLATFORM_SUBDIR)/boot.bin
	$(SCRIPT_DIR)/ndm_bin_gen_header.sh $$< $$@

  $(STAMP_CONFIGURED): $(STAMP_PREPARED) $(LINUX_KCONFIG_LIST) $(TOPDIR)/.config
	$(Kernel/Configure)
	touch $$@

  $(LINUX_DIR)/.modules: $(STAMP_CONFIGURED) $(LINUX_DIR)/.config FORCE
	$(Kernel/CompileModules)
	touch $$@

  $(LINUX_DIR)/.image: $(STAMP_CONFIGURED) $(if $(CONFIG_STRIP_KERNEL_EXPORTS),$(KERNEL_BUILD_DIR)/symtab.h) $(if $(CONFIG_KERNEL_MTD_NDM_PRELOADER_UPDATE),$(NDM_PRELOADER_HEADER)) $(if $(CONFIG_KERNEL_MTD_NDM_ATF_UPDATE),$(NDM_ATF_HEADER)) $(if $(CONFIG_KERNEL_MTD_NDM_BOOT_UPDATE),$(NDM_BOOT_HEADER)) FORCE
	$(Kernel/CompileImage)
	$(Kernel/CollectDebug)
	touch $$@

  mostlyclean: FORCE
	$(Kernel/Clean)

  define BuildKernel
  endef

  download: $(DL_DIR)/linux-$(KERNEL_GIT_REVISION).tar.zst
  prepare: $(STAMP_CONFIGURED)
  compile: $(LINUX_DIR)/.modules
	$(MAKE) -C image compile TARGET_BUILD=

  oldconfig menuconfig nconfig: $(STAMP_PREPARED) $(STAMP_CHECKED) FORCE
	rm -f $(STAMP_CONFIGURED)
	$(LINUX_RECONF_CMD) > $(LINUX_DIR)/.config.reconf
	$(_SINGLE) KCONFIG_CONFIG=$(LINUX_DIR)/.config.reconf $(KERNEL_MAKE) $$@
	$(LINUX_RECONF_DIFF) $(LINUX_DIR)/.config.reconf > $(LINUX_RECONFIG_TARGET)

  install: $(LINUX_DIR)/.image
	+$(MAKE) -C image compile install TARGET_BUILD=

  clean: FORCE
	rm -rf $(KERNEL_BUILD_DIR)

  image-prereq:
	@+$(NO_TRACE_MAKE) -s -C image prereq TARGET_BUILD=

  prereq: image-prereq

endef

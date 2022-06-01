#
# Copyright (C) 2006-2011 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
# Main makefile for the host tools
#
curdir:=tools

# subdirectories to descend into
tools-y :=

ifdef CONFIG_GCC_USE_GRAPHITE
  ifeq ($(CONFIG_GCC_USE_SYSTEM_PPL_CLOOG),)
    BUILD_PPL_CLOOG = y
  endif
endif

ifeq ($(wildcard $(SCRIPT_DIR)/private),)
  BUILD_ZYIMAGE = y
endif

tools-y += m4 libtool autoconf automake flex bison pkg-config ragel
tools-y += sstrip ipkg-utils cmake missing-macros
tools-y += quilt mkimage libndm libndmfw ndmfw tze
tools-y += lzma squashfskit4 node
tools-y += gengetopt patchelf
tools-y += discount links
tools-$(CONFIG_KERNEL_IMAGE_CMDLINE_HACK) += patch-cmdline
tools-$(CONFIG_USE_MKLIBS) += mklibs
tools-$(CONFIG_USE_SPARSE) += sparse
tools-$(BUILD_PPL_CLOOG) += ppl cloog
tools-$(BUILD_ZYIMAGE) += zyimage

# builddir dependencies
$(curdir)/bison/compile := $(curdir)/flex/install
$(curdir)/flex/compile := $(curdir)/automake/install
$(curdir)/libtool/compile := $(curdir)/automake/install $(curdir)/missing-macros/install
$(curdir)/quilt/compile := $(curdir)/autoconf/install
$(curdir)/autoconf/compile := $(curdir)/m4/install
$(curdir)/automake/compile := $(curdir)/m4/install $(curdir)/autoconf/install $(curdir)/pkg-config/install $(curdir)/missing-macros/install
$(curdir)/gmp/compile := $(curdir)/automake/install
$(curdir)/mpc/compile := $(curdir)/mpfr/install $(curdir)/gmp/install
$(curdir)/mpfr/compile := $(curdir)/gmp/install
$(curdir)/ppl/compile := $(curdir)/gmp/install
$(curdir)/cloog/compile := $(curdir)/ppl/install
$(curdir)/mklibs/compile := $(curdir)/automake/install
$(curdir)/missing-macros/compile := $(curdir)/automake/install
$(curdir)/gengetopt/compile := $(curdir)/automake/install $(curdir)/libtool/install
$(curdir)/patchelf/compile := $(curdir)/libtool/install
$(curdir)/libndmfw/compile := $(curdir)/libndm/install
$(curdir)/links/compile := $(curdir)/automake/install
$(curdir)/ndmfw/compile := $(curdir)/libndmfw/install
$(curdir)/cloog/compile := $(curdir)/ppl/install

ifneq ($(CONFIG_CCACHE),)
$(foreach tool, $(filter-out xz,$(tools-y)), $(eval $(curdir)/$(tool)/compile += $(curdir)/ccache/install))
tools-y += ccache
endif

# make any tool depend on tar and xz to ensure that archives can be unpacked properly
tools-core := tar xz zstd

$(foreach tool, $(tools-y), $(eval $(curdir)/$(tool)/compile += $(patsubst %,$(curdir)/%/install,$(tools-core))))
tools-y += $(tools-core)

# make core tools depend on sed and flock
$(foreach tool, $(filter-out xz,$(tools-core)), $(eval $(curdir)/$(tool)/compile += $(curdir)/sed/install))
$(curdir)/tar/compile += $(curdir)/zstd/install	# SYS-408
$(curdir)/xz/compile += $(curdir)/flock/install
$(curdir)/zstd/compile += $(curdir)/flock/install

$(curdir)/sed/compile := $(curdir)/flock/install $(curdir)/xz/install
tools-y += flock sed

$(curdir)/builddirs := $(tools-y) $(tools-dep) $(tools-)
$(curdir)/builddirs-default := $(tools-y)

ifndef DUMP_TARGET_DB
define PrepareStaging
	@for dir in $(1); do ( \
		$(if $(QUIET),,set -x;) \
		mkdir -p "$$dir"; \
		cd "$$dir"; \
		mkdir -p bin lib include stamp; \
	); done
endef

# preparatory work
$(STAGING_DIR)/.prepared: $(TMP_DIR)/.build
	$(call PrepareStaging,$(STAGING_DIR))
	mkdir -p $(BUILD_DIR)/stamp
	touch $@

$(STAGING_DIR_HOST)/.prepared: $(TMP_DIR)/.build
	$(call PrepareStaging,$(STAGING_DIR_HOST))
	mkdir -p $(BUILD_DIR_HOST)/stamp $(STAGING_DIR_HOST)/include/sys
	$(INSTALL_DATA) $(TOPDIR)/tools/include/*.h $(STAGING_DIR_HOST)/include/
	$(INSTALL_DATA) $(TOPDIR)/tools/include/sys/*.h $(STAGING_DIR_HOST)/include/sys/
	ln -sf lib $(STAGING_DIR_HOST)/lib64
	touch $@


define PrepareCommand
$(STAGING_DIR_HOST)/bin/$(1): $(STAGING_DIR)/.prepared $(STAGING_DIR_HOST)/.prepared
	@mkdir -p "$$(dir $$@)"; rm -f "$$@"
	@export FILE="$$$$(which $(2) 2>/dev/null | grep -v 'not found' | head -n1)"; [ -n "$$$$FILE" ] || { \
		echo "Command $(1) not found."; false; \
	}; ln -s "$$$$FILE" "$$@"

endef
endif

$(STAGING_DIR_HOST)/bin/stat: $(STAGING_DIR)/.prepared $(STAGING_DIR_HOST)/.prepared
	@mkdir -p "$(dir $@)"; rm -f "$@"
	@if stat --version > /dev/null 2>&1; then \
		ln -s `which stat` $@; \
	elif gstat --version > /dev/null 2>&1; then \
		ln -s `which gstat` $@; \
	else \
		echo "GNU stat not found"; \
		false; \
	fi

$(STAGING_DIR_HOST)/bin/cp: $(STAGING_DIR)/.prepared $(STAGING_DIR_HOST)/.prepared
	@mkdir -p "$(dir $@)"; rm -f "$@"
	@if gcp --help 2>&1 | grep 'Copy SOURCE' > /dev/null 2>&1; then \
		ln -s `which gcp` $@; \
	elif cp --help 2>&1 | grep 'Copy SOURCE' > /dev/null 2>&1; then \
		ln -s `which cp` $@; \
	else \
		echo "GNU cp not found"; \
		false; \
	fi

$(eval $(call PrepareCommand,find,gfind find))
$(eval $(call PrepareCommand,grep,ggrep grep))
$(eval $(call PrepareCommand,md5sum,gmd5sum md5sum $(SCRIPT_DIR)/md5sum))
$(eval $(call PrepareCommand,seq,gseq seq))
$(eval $(call PrepareCommand,python,python2 python))

$(curdir)/cmddeps = $(patsubst %,$(STAGING_DIR_HOST)/bin/%,find grep md5sum cp stat seq python)
$(curdir)//prepare = $(STAGING_DIR)/.prepared $(STAGING_DIR_HOST)/.prepared $($(curdir)/cmddeps)
$(curdir)//compile = $(STAGING_DIR)/.prepared $(STAGING_DIR_HOST)/.prepared $($(curdir)/cmddeps)

# prerequisites for the individual targets
$(curdir)/ := .config prereq
$(curdir)//install = $(1)/compile

tools_enabled = $(foreach tool,$(sort $(tools-y) $(tools-)),$(if $(filter $(tool),$(tools-y)),y,n))
$(eval $(call stampfile,$(curdir),tools,install,,_$(subst $(space),,$(tools_enabled))))
$(eval $(call stampfile,$(curdir),tools,check,$(TMP_DIR)/.build))
$(eval $(call subdir,$(curdir)))

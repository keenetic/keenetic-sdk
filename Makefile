# Makefile for OpenWrt
#
# Copyright (C) 2007 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

TOPDIR:=${CURDIR}
LC_ALL:=C
LANG:=C
export TOPDIR LC_ALL LANG

world:

include $(TOPDIR)/include/host.mk

ifneq ($(OPENWRT_BUILD),1)
  # XXX: these three lines are normally defined by rules.mk
  # but we can't include that file in this context
  empty:=
  space:= $(empty) $(empty)
  _SINGLE=export MAKEFLAGS=$(space);

  override OPENWRT_BUILD=1
  export OPENWRT_BUILD
  GREP_OPTIONS=
  export GREP_OPTIONS
  include $(TOPDIR)/include/debug.mk
  include $(TOPDIR)/include/depends.mk
  include $(TOPDIR)/include/toplevel.mk
else
  include rules.mk
  include $(INCLUDE_DIR)/depends.mk
  include $(INCLUDE_DIR)/subdir.mk
  include target/Makefile
  include package/Makefile
  include tools/Makefile
  include toolchain/Makefile

$(toolchain/stamp-install): $(tools/stamp-install)
$(target/stamp-compile): $(toolchain/stamp-install) $(tools/stamp-install) $(BUILD_DIR)/.prepared
$(package/stamp-compile): $(target/stamp-compile) $(package/stamp-cleanup)
$(package/stamp-install): $(package/stamp-compile)
$(target/stamp-install): $(package/stamp-compile) $(package/stamp-install)
check: $(tools/stamp-check) $(toolchain/stamp-check) $(package/stamp-check)

export NDM_VERSION = $(shell echo $(CONFIG_TARGET_VERSION) | \
	sed -e 's/~e/$(NDM_EPOCH)/g' \
		-e 's/~j/$(NDM_MAJOR)/g' \
		-e 's/~n/$(NDM_MINOR)/g' \
		-e 's/~s/$(NDM_STAGE)/g' \
		-e 's/~t/$(NDM_MAINT)/g' \
		-e 's/\((\|)\| \)/\\\1/g')

export NDM_VERSION_EXACT = $(shell echo $(CONFIG_TARGET_VERSION) | \
	sed -e 's/~e/$(NDM_EPOCH)/g' \
		-e 's/~j/$(NDM_MAJOR)/g' \
		-e 's/~n/$(NDM_MINOR)/g' \
		-e 's/~s/$(NDM_STAGE)/g' \
		-e 's/~t/$(NDM_MAINT)$(NDM_EXACT)/g' \
		-e 's/\((\|)\| \)/\\\1/g')

printdb:
	@true

prepare: $(target/stamp-compile)

clean: FORCE
	$(_SINGLE)$(SUBMAKE) target/linux/clean
	rm -rf $(BUILD_DIR) $(BIN_DIR) $(BUILD_LOG_DIR) release.mk

dirclean: clean
	rm -rf $(STAGING_DIR) $(STAGING_DIR_HOST) $(STAGING_DIR_TOOLCHAIN) $(TOOLCHAIN_DIR) $(BUILD_DIR_HOST) $(BUILD_DIR_TOOLCHAIN) $(TMP_DIR)
	[ -d $(SCRIPT_DIR)/private ] || find package -type d -name 'files-*' | $(XARGS) rm -rf

ifndef DUMP_TARGET_DB
$(BUILD_DIR)/.prepared: Makefile
	@mkdir -p $$(dirname $@)
	@touch $@

tmp/.prereq_packages: .config
	unset ERROR; \
	for package in $(sort $(prereq-y) $(prereq-m)); do \
		$(_SINGLE)$(NO_TRACE_MAKE) -s -r -C package/$$package prereq || ERROR=1; \
	done; \
	if [ -n "$$ERROR" ]; then \
		echo "Package prerequisite check failed."; \
		false; \
	fi
	touch $@
endif

# check prerequisites before starting to build
prereq: $(target/stamp-prereq) tmp/.prereq_packages
	@if [ ! -f "$(INCLUDE_DIR)/site/$(REAL_GNU_TARGET_NAME)" ]; then \
		echo 'ERROR: Missing site config for target "$(REAL_GNU_TARGET_NAME)" !'; \
		echo '       The missing file will cause configure scripts to fail during compilation.'; \
		echo '       Please provide a "$(INCLUDE_DIR)/site/$(REAL_GNU_TARGET_NAME)" file and restart the build.'; \
		exit 1; \
	fi
	
prepare: .config $(tools/stamp-install) $(toolchain/stamp-install)
index:
	$(_SINGLE)$(SUBMAKE) -r package/index
world: prepare $(target/stamp-compile) $(package/stamp-compile) $(package/stamp-install) $(target/stamp-install) FORCE

# update all feeds, re-create index files, install symlinks
package/symlinks:
	$(SCRIPT_DIR)/feeds update -a
	$(SCRIPT_DIR)/feeds install -a

# re-create index files, install symlinks
package/symlinks-install:
	$(SCRIPT_DIR)/feeds update -i
	$(SCRIPT_DIR)/feeds install -a

# remove all symlinks, don't touch ./feeds
package/symlinks-clean:
	$(SCRIPT_DIR)/feeds uninstall -a

.PHONY: clean dirclean prereq prepare world package/symlinks package/symlinks-install package/symlinks-clean

endif

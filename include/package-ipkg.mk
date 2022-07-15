#
# Copyright (C) 2006,2007 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

# invoke ipkg-build with some default options
IPKG_BUILD:= \
  ipkg-build -c -o 0 -g 0

IPKG_REMOVE:= \
  $(SCRIPT_DIR)/ipkg-remove

IPKG_STATE_DIR:=$(TARGET_DIR)/usr/lib/opkg

define BuildIPKGVariable
ifdef Package/$(1)/$(2)
  $(call shexport,Package/$(1)/$(2))
  $(1)_COMMANDS += var2file "$(call shvar,Package/$(1)/$(2))" $(2);
endif
endef

PARENL :=(
PARENR :=)

dep_split=$(subst :,$(space),$(1))
dep_rem=$(subst !,,$(subst $(strip $(PARENL)),,$(subst $(strip $(PARENR)),,$(word 1,$(call dep_split,$(1))))))
dep_confvar=$(strip $(foreach cond,$(subst ||, ,$(call dep_rem,$(1))),$(CONFIG_$(cond))))
dep_pos=$(if $(call dep_confvar,$(1)),$(call dep_val,$(1)))
dep_neg=$(if $(call dep_confvar,$(1)),,$(call dep_val,$(1)))
dep_if=$(if $(findstring !,$(1)),$(call dep_neg,$(1)),$(call dep_pos,$(1)))
dep_val=$(word 2,$(call dep_split,$(1)))
strip_deps=$(strip $(subst +,,$(filter-out @%,$(1))))
filter_deps=$(foreach dep,$(call strip_deps,$(1)),$(if $(findstring :,$(dep)),$(call dep_if,$(dep)),$(dep)))

opkg_package_files = $(wildcard \
	$(foreach dir,$(PACKAGE_DIR), \
	  $(foreach pkg,$(1), $(dir)/$(pkg)_*.ipk)))

define AddDependency
  $$(if $(1),$$(if $(2),$$(foreach pkg,$(1),$$(IPKG_$$(pkg))): $$(foreach pkg,$(2),$$(IPKG_$$(pkg)))))
endef

define FixupReverseDependencies
  DEPS := $$(filter %:$(1),$$(IDEPEND))
  DEPS := $$(patsubst %:$(1),%,$$(DEPS))
  DEPS := $$(filter $$(DEPS),$$(IPKGS))
  $(call AddDependency,$$(DEPS),$(1))
endef

define FixupDependencies
  DEPS := $$(filter $(1):%,$$(IDEPEND))
  DEPS := $$(patsubst $(1):%,%,$$(DEPS))
  DEPS := $$(filter $$(DEPS),$$(IPKGS))
  $(call AddDependency,$(1),$$(DEPS))
endef

ifeq ($(filter base-files toolchain,$(PKG_NAME)),)
  define CheckDependencies
	@( \
		rm -f $(PKG_INFO_DIR)/$(1).missing; \
		( \
			export \
				READELF=$(TARGET_CROSS)readelf \
				OBJCOPY=$(TARGET_CROSS)objcopy \
				XARGS="$(XARGS)"; \
			$(SCRIPT_DIR)/gen-dependencies.sh "$$(IDIR_$(1))"; \
		) | while read FILE; do \
			grep -qxF "$$$$FILE" $(PKG_INFO_DIR)/$(1).provides || \
				echo "$$$$FILE" >> $(PKG_INFO_DIR)/$(1).missing; \
		done; \
		if [ -f "$(PKG_INFO_DIR)/$(1).missing" ]; then \
			echo "Package $(1) is missing dependencies for the following libraries:" >&2; \
			cat "$(PKG_INFO_DIR)/$(1).missing" >&2; \
			false; \
		fi; \
	)
  endef
endif

ifeq ($(DUMP),)
  define BuildTarget/ipkg
    IPKG_$(1):=$(PACKAGE_DIR)/$(1)_$(VERSION)_$(PKGARCH).ipk
    IDIR_$(1):=$(PKG_BUILD_DIR)/ipkg-$(PKGARCH)/$(1)
    KEEP_$(1):=$(strip $(call Package/$(1)/conffiles))
    LDIR_$(1):=$$(IDIR_$(1))/usr/share/packages/$(1)
    LDIR_common_$(1):=$$(IDIR_$(1))/usr/share/packages/common

    ifeq ($(BUILD_VARIANT),$$(if $$(VARIANT),$$(VARIANT),$(BUILD_VARIANT)))

    do_install=
    ifdef Package/$(1)/install
      do_install=yes
    endif

    ifneq ($(LICENSE)$(LICENSE_FILES),)
      do_install=yes
    endif

    ifdef do_install
      ifneq ($(CONFIG_PACKAGE_$(1))$(SDK)$(DEVELOPER),)
        IPKGS += $(1)
        compile: $$(IPKG_$(1)) $(PKG_INFO_DIR)/$(1).provides $(STAGING_DIR_ROOT)/stamp/.$(1)_installed
      else
        $(if $(CONFIG_PACKAGE_$(1)),$$(info WARNING: skipping $(1) -- package not selected))
      endif

      .PHONY: $(PKG_INSTALL_STAMP).$(1)
      compile: $(PKG_INSTALL_STAMP).$(1)
      $(PKG_INSTALL_STAMP).$(1):
			if [ -f $(PKG_INSTALL_STAMP).clean ]; then \
				rm -f \
					$(PKG_INSTALL_STAMP) \
					$(PKG_INSTALL_STAMP).clean; \
			fi
      ifeq ($(CONFIG_PACKAGE_$(1)),y)
			echo "$(1)" >> $(PKG_INSTALL_STAMP)
      endif
    endif
    endif

    DEPENDS:=$(call PKG_FIXUP_DEPENDS,$(1),$(DEPENDS))
    IDEPEND_$(1):=$$(call filter_deps,$$(DEPENDS))
    IDEPEND += $$(patsubst %,$(1):%,$$(IDEPEND_$(1)))
    $(FixupDependencies)
    $(FixupReverseDependencies)

    $(eval $(call BuildIPKGVariable,$(1),conffiles))
    $(eval $(call BuildIPKGVariable,$(1),preinst))
    $(eval $(call BuildIPKGVariable,$(1),postinst))
    $(eval $(call BuildIPKGVariable,$(1),prerm))
    $(eval $(call BuildIPKGVariable,$(1),postrm))

    $(STAGING_DIR_ROOT)/stamp/.$(1)_installed: $(STAMP_BUILT)
	rm -rf $(STAGING_DIR_ROOT)/tmp-$(1)
	mkdir -p $(STAGING_DIR_ROOT)/stamp $(STAGING_DIR_ROOT)/tmp-$(1)
	$(call Package/$(1)/install,$(STAGING_DIR_ROOT)/tmp-$(1))
	$(call Package/$(1)/install_lib,$(STAGING_DIR_ROOT)/tmp-$(1))
	$(call locked,$(CP) $(STAGING_DIR_ROOT)/tmp-$(1)/. $(STAGING_DIR_ROOT)/,root-copy)
	rm -rf $(STAGING_DIR_ROOT)/tmp-$(1)
	touch $$@

    $(PKG_INFO_DIR)/$(1).provides: $$(IPKG_$(1))
    $$(IPKG_$(1)): $(STAMP_BUILT) $(INCLUDE_DIR)/package-ipkg.mk
	@rm -rf $$(IDIR_$(1)) $$(if $$(call opkg_package_files,$(1)*),; $$(IPKG_REMOVE) $(1) $$(call opkg_package_files,$(1)*))
	mkdir -p $(PACKAGE_DIR) $$(IDIR_$(1))/CONTROL $$(LDIR_$(1)) $$(LDIR_common_$(1)) $(PKG_INFO_DIR)
	$(call Package/$(1)/install,$$(IDIR_$(1)))
	-find $$(IDIR_$(1)) -name 'CVS' -o -name '.svn' -o -name '.#*' -o -name '*~'| $(XARGS) rm -rf
	@( \
		find $$(IDIR_$(1)) -name lib\*.so\* -or -name \*.ko | awk -F/ '{ print $$$$NF }'; \
		for file in $$(patsubst %,$(PKG_INFO_DIR)/%.provides,$$(IDEPEND_$(1))); do \
			if [ -f "$$$$file" ]; then \
				cat $$$$file; \
			fi; \
		done; $(Package/$(1)/extra_provides) \
	) | sort -u > $(PKG_INFO_DIR)/$(1).provides
	( \
		cd $$(IDIR_$(1)); \
		find . -name \*.so\*; \
	) > $(PKG_INFO_DIR)/$(1).libs
	[ -s $(PKG_INFO_DIR)/$(1).libs ] || rm $(PKG_INFO_DIR)/$(1).libs
	$(if $(PROVIDES),@for pkg in $(PROVIDES); do cp $(PKG_INFO_DIR)/$(1).provides $(PKG_INFO_DIR)/$$$$pkg.provides; done)
	$(CheckDependencies)

	$(if $(DISABLE_RSTRIP),,$(RSTRIP) $$(IDIR_$(1)))
	( \
		echo "Package: $(1)"; \
		echo "Version: $(VERSION)"; \
		DEPENDS='$(EXTRA_DEPENDS)'; \
		for depend in $$(filter-out @%,$$(IDEPEND_$(1))); do \
			DEPENDS=$$$${DEPENDS:+$$$$DEPENDS, }$$$${depend##+}; \
		done; \
		echo "Depends: $$$$DEPENDS"; \
		CONFLICTS=''; \
		for conflict in $(CONFLICTS); do \
			CONFLICTS=$$$${CONFLICTS:+$$$$CONFLICTS, }$$$$conflict; \
		done; \
		echo "Conflicts: $$$$CONFLICTS"; \
		echo "Provides: $(PROVIDES)"; \
		echo "Source: $(SOURCE)"; \
		echo "SourceName: $(1)"; \
		echo "License: $(LICENSE)"; \
		echo "LicenseFiles: $(LICENSE_FILES)"; \
		echo "Section: $(SECTION)"; \
		echo "Submenu: $(SUBMENU)"; \
		echo "Status: unknown $(if $(filter hold,$(PKG_FLAGS)),hold,ok) not-installed"; \
		echo "Essential: $(if $(filter essential,$(PKG_FLAGS)),yes,no)"; \
		MODULES=''; \
		for module in $$$$($(SH_FUNC) getvar $(call shvar,Package/$(1)/modules)); do \
			MODULES=$$$${MODULES:+$$$$MODULES,}$$$$module; \
		done; \
		echo "Modules: $$$$MODULES"; \
		ALIAS=''; \
		for alias in $(ALIAS); do \
			ALIAS=$$$${ALIAS:+$$$$ALIAS,}$$$$alias; \
		done; \
		echo "Alias: $$$$ALIAS"; \
		echo "Priority: $(PRIORITY)"; \
		echo "Preset: $(PRESET)"; \
		REGIONS=''; \
		for region in $(REGIONS); do \
			REGIONS=$$$${REGIONS:+$$$$REGIONS,}$$$$region; \
		done; \
		echo "Regions: $$$$REGIONS"; \
		echo "Hidden: $(HIDDEN)"; \
		echo "Implicit: $(IMPLICIT)"; \
		echo "Obsolete: $(OBSOLETE)"; \
		echo "Stage: $(STAGE)"; \
		echo "Sort-Order: $(SORT_ORDER)"; \
		echo "Master-Package: $(MASTER_PACKAGE)"; \
		echo "Maintainer: $(MAINTAINER)"; \
		echo "Architecture: $(PKGARCH)"; \
		echo "Installed-Size: 0"; \
		echo -n "Description: "; $(SH_FUNC) getvar $(call shvar,Package/$(1)/description) | \
			sed -e 's,^[[:space:]]*, ,g'; \
			echo; \
		for mode in $(call qstrip,$(CONFIG_SYSTEM_MODES)); do \
			echo -n "Script-$$$$(echo $$$$mode | sed 's/./\U&/'): "; \
			$(SH_FUNC) getvar $(call shvar,Package/$(1)/script/$$$$mode) | \
			($(SCRIPT_DIR)/ndm_include.pl $$(IDIR_$(1))/flash || exit 1) | \
			base64 --wrap=0; \
			echo; \
		done \
 	) > $$(IDIR_$(1))/CONTROL/control
	if [ ! -f $$(LDIR_$(1))/TITLE ]; then \
		[ -z "$(URL)" ] || echo "$(URL)" > $$(LDIR_$(1))/HOMEPAGE; \
		[ -z "$(TITLE)" ] || echo "$(TITLE)" > $$(LDIR_$(1))/TITLE; \
		i=1; \
		for license in $(LICENSE); do \
			license=$$$$(echo $$$${license%+} | tr '[:upper:]' '[:lower:]'); \
			src=$(LICENSES_DIR)/$$$${license}.txt; \
			dst=$$(LDIR_$(1))/COPYING.$$$$i; \
			[ ! -e $$$$src ] && continue; \
			cp $$$$src $$(LDIR_common_$(1)); \
			t=$$(LDIR_common_$(1))/$$$${src##*/}; \
			ln -s $$$${t#$$(IDIR_$(1))} $$$$dst; \
			i=$$$$((i+1)); \
		done; \
		for license in $(LICENSE_FILES); do \
			src=$(PKG_BUILD_DIR)/$$$$license; \
			dst=$$(LDIR_$(1))/COPYING.$$$$i; \
			[ $$$$license != $$$${license#/} ] && src=$$$$license; \
			if [ ! -f $$$$src ]; then \
				echo "License file \"$$$$src\" doesn't exist." >&2; \
				exit 1; \
			fi; \
			cp $$$$src $$$$dst; \
			$(SED) 's/\f//' $$$$dst; \
			i=$$$$((i+1)); \
		done; \
		[ $$$$i -ne 1 ] || rm -rf $$(LDIR_$(1)); \
	fi
	chmod 644 $$(IDIR_$(1))/CONTROL/control
	$(if $(filter private,$(PKGFLAGS)),find $$(IDIR_$(1)) -type f -print0 | xargs -0 setfattr -n user.package -v $(1))
	$(SH_FUNC) (cd $$(IDIR_$(1))/CONTROL; \
		$($(1)_COMMANDS) \
	)

    ifneq ($$(KEEP_$(1)),)
		@( \
			keepfiles=""; \
			for x in $$(KEEP_$(1)); do \
				[ -f "$$(IDIR_$(1))/$$$$x" ] || keepfiles="$$$${keepfiles:+$$$$keepfiles }$$$$x"; \
			done; \
			[ -z "$$$$keepfiles" ] || { \
				mkdir -p $$(IDIR_$(1))/lib/upgrade/keep.d; \
				for x in $$$$keepfiles; do echo $$$$x >> $$(IDIR_$(1))/lib/upgrade/keep.d/$(1); done; \
			}; \
		)
    endif

	$(IPKG_BUILD) $$(IDIR_$(1)) $(PACKAGE_DIR)
	@[ -f $$(IPKG_$(1)) ]

    $(1)-clean:
	$$(if $$(call opkg_package_files,$(1)*),$$(IPKG_REMOVE) $(1) $$(call opkg_package_files,$(1)*))

    clean: $(1)-clean

  endef
endif

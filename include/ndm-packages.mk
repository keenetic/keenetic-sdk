ifeq ($(BUILD_PACKAGES),)
NDM_PACKAGES := $(filter-out Components, $(shell $(subst CONFIG_PACKAGE_ndm-mod-,,$(foreach b, $(filter CONFIG_PACKAGE_ndm-mod-%,$(sort $(.VARIABLES))), \
		if [ "$($b)" == "y" ]; then \
			echo $b; \
		fi; \
	))))
else
NDM_PACKAGES = $(subst ndm-mod-,,$(shell grep "ndm-mod-" $(TMP_DIR)/.build_packages))
NDM_UNHIDDEN_PACKAGES := $(subst ndm-mod-,,$(filter ndm-mod-%,$(BUILD_UNHIDDEN_PACKAGES)))
endif

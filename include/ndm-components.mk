ifeq ($(BUILD_PACKAGES),)
  NDM_COMPONENTS_A:=$(patsubst CONFIG_PACKAGE_ndm-mod-%,%,\
	$(filter CONFIG_PACKAGE_ndm-mod-%,$(sort $(.VARIABLES))))
  NDM_COMPONENTS_M:=$(patsubst CONFIG_PACKAGE_ndm-mod-%=m,%,$(filter %=m,\
	$(foreach p,$(filter CONFIG_PACKAGE_ndm-mod-%,$(sort $(.VARIABLES))),$p=$(value $p))))
  NDM_COMPONENTS_Y:=$(patsubst CONFIG_PACKAGE_ndm-mod-%=y,%,$(filter %=y,\
	$(foreach p,$(filter CONFIG_PACKAGE_ndm-mod-%,$(sort $(.VARIABLES))),$p=$(value $p))))
else
  NDM_COMPONENTS_Y:=$(patsubst ndm-mod-%,%,$(shell grep ndm-mod- $(TMP_DIR)/.build_packages))
  NDM_COMPONENTS_U:=$(patsubst ndm-mod-%,%,$(filter ndm-mod-%,$(BUILD_UNHIDDEN_PACKAGES)))
endif

# ndm build parameters

Equal = $(if $(filter-out xx,x$(subst $1,,$2)$(subst $2,,$1)x),,xx)
Empty = $(or \
    $(call Equal,xx,x$(strip $(subst "",,$1))x),\
    $(call Equal,xx,x$(strip $(subst '',,$1))x))

define StringMacro
-D__$(subst CONFIG_,,$1)__=\"\\\"$(strip $(shell echo $($1)))\\\"\"
endef

TARGET_NDM_CPPFLAGS := -D__TARGET_DEVICE_TYPE__=\"\\\"$(DEVICE_TYPE)\\\"\"
TARGET_NDM_CPPFLAGS += -D__TARGET_BOARD__=\"\\\"$(CONFIG_TARGET_ARCH_PACKAGES)\\\"\"
TARGET_NDM_CPPFLAGS += $(call StringMacro,CONFIG_TARGET_DEFAULT_PRODUCT)
TARGET_NDM_CPPFLAGS += $(call StringMacro,CONFIG_TARGET_VENDOR)
TARGET_NDM_CPPFLAGS += $(call StringMacro,CONFIG_TARGET_VENDOR_SHORT)
TARGET_NDM_CPPFLAGS += $(call StringMacro,CONFIG_TARGET_DEVICE_MANUFACTURER)
TARGET_NDM_CPPFLAGS += $(call StringMacro,CONFIG_TARGET_MODEL_SERIES)
TARGET_NDM_CPPFLAGS += $(call StringMacro,CONFIG_TARGET_VENDOR_URL)
TARGET_NDM_CPPFLAGS += $(call StringMacro,CONFIG_TARGET_VENDOR_EMAIL)
TARGET_NDM_CPPFLAGS += $(call StringMacro,CONFIG_TARGET_CUSTOMER)
TARGET_NDM_CPPFLAGS += $(call StringMacro,CONFIG_TARGET_FEATURES)

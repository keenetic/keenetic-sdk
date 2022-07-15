#
# Copyright (C) 2022 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=nvox
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define Package/nvox
  CATEGORY:=Multimedia
  TITLE:=NDM telephony
  DEPENDS:=+libc +SSP_SUPPORT:libssp +fxs +kmod-usb-acm +libopenssl +libsupcxx +libusb +pjproject +ca-certificates +NVOX_MIMALLOC:libatomic +NVOX_MIMALLOC:mimalloc +USE_GLIBC:libc-locales
  DISABLE_RSTRIP:=y
endef

define Package/nvox/config
	config NVOX_BACKTRACE
		bool "Backtrace"
		depends on PACKAGE_nvox
		default n
	config NVOX_DECT
		bool "DECT support"
		depends on PACKAGE_nvox
		default y
	config NVOX_VERBOSE
		bool "Verbose app logs"
		depends on PACKAGE_nvox
		default n
	config NVOX_MIMALLOC
		bool
		depends on PACKAGE_nvox
		default y if PJPROJECT_MIMALLOC
endef

define Package/nvox/install
	if [ -d ./files-nvox ]; then \
		$(CP) ./files-nvox/* $(1); \
	fi
endef

$(eval $(call BuildPackage,nvox))

define Package/nvox-fxs-prod-flash
  CATEGORY:=Multimedia
  TITLE:=NDM telephony (FXS flasher)
  DEPENDS:=+libc +SSP_SUPPORT:libssp +fxs +kmod-usb-acm +libopenssl +libsupcxx +libusb +pjproject +ca-certificates +NVOX_MIMALLOC:libatomic +NVOX_MIMALLOC:mimalloc +USE_GLIBC:libc-locales
  DISABLE_RSTRIP:=y
endef

define Package/nvox-fxs-prod-flash/install
	if [ -d ./files-nvox-fxs-prod-flash ]; then \
		$(CP) ./files-nvox-fxs-prod-flash/* $(1); \
	fi
endef

$(eval $(call BuildPackage,nvox-fxs-prod-flash))

define Package/nvox-fxs-prod-int
  CATEGORY:=Multimedia
  TITLE:=NDM telephony (FXS inward tests)
  DEPENDS:=+libc +SSP_SUPPORT:libssp +fxs +kmod-usb-acm +libopenssl +libsupcxx +libusb +pjproject +ca-certificates +NVOX_MIMALLOC:libatomic +NVOX_MIMALLOC:mimalloc +USE_GLIBC:libc-locales
  DISABLE_RSTRIP:=y
endef

define Package/nvox-fxs-prod-int/install
	if [ -d ./files-nvox-fxs-prod-int ]; then \
		$(CP) ./files-nvox-fxs-prod-int/* $(1); \
	fi
endef

$(eval $(call BuildPackage,nvox-fxs-prod-int))

define Package/nvox-fxs-prod-test
  CATEGORY:=Multimedia
  TITLE:=NDM telephony (FXS tester)
  DEPENDS:=+libc +SSP_SUPPORT:libssp +fxs +kmod-usb-acm +libopenssl +libsupcxx +libusb +pjproject +ca-certificates +NVOX_MIMALLOC:libatomic +NVOX_MIMALLOC:mimalloc +USE_GLIBC:libc-locales
  DISABLE_RSTRIP:=y
endef

define Package/nvox-fxs-prod-test/install
	if [ -d ./files-nvox-fxs-prod-test ]; then \
		$(CP) ./files-nvox-fxs-prod-test/* $(1); \
	fi
endef

$(eval $(call BuildPackage,nvox-fxs-prod-test))

#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk

# Host-only package: the official binary release of the Go toolchain for the
# machine that builds the firmware. It is used to build packages written in Go
# (for example dnscrypt-proxy). Nothing from it is installed on the device.
#
# Keep the version in step with the "go" line in the go.mod of the Go packages
# that use it. The Go versions that work for them are listed in their README.
PKG_NAME:=golang
PKG_VERSION:=1.27.4

PKG_LICENSE:=BSD-3-Clause
PKG_LICENSE_FILES:=LICENSE

PKG_HOST_ONLY:=1

GO_HOST_MACHINE:=$(shell uname -m)
ifeq ($(GO_HOST_MACHINE),x86_64)
  GO_HOST_ARCH:=amd64
  PKG_HASH:=7226736c2339719cda28fbf3a54d71aa63bcefe376e98cef00034268dab24840
else ifneq ($(filter aarch64 arm64,$(GO_HOST_MACHINE)),)
  GO_HOST_ARCH:=arm64
  PKG_HASH:=3392582988a273a87ab5043ee1b2c9c17a2c3c00580bf9326c47a2e0aaaeac92
endif

PKG_SOURCE:=go$(PKG_VERSION).linux-$(GO_HOST_ARCH).tar.gz
PKG_SOURCE_URL:=https://dl.google.com/go https://go.dev/dl

# The archive unpacks into a directory called "go", not "golang-<version>".
HOST_BUILD_DIR:=$(BUILD_DIR_HOST)/go

include $(INCLUDE_DIR)/host-build.mk
include $(INCLUDE_DIR)/package.mk

define Package/golang
  SECTION:=devel
  CATEGORY:=Development
  TITLE:=Go toolchain (build host only)
  URL:=https://go.dev/
  BUILDONLY:=1
endef

define Package/golang/description
  The official Go toolchain for the build host. It is only used to compile
  other packages and is never installed on the device.
endef

GO_HOST_ROOT:=$(STAGING_DIR_HOST)/lib/go

define Host/Prepare
	$(if $(GO_HOST_ARCH),,$(error golang: no Go toolchain is configured for the build host architecture '$(GO_HOST_MACHINE)'))
	$(call Host/Prepare/Default)
endef

define Host/Configure
endef

define Host/Compile
endef

define Host/Install
	$(INSTALL_DIR) $(STAGING_DIR_HOST)/lib
	rm -rf $(GO_HOST_ROOT)
	$(CP) $(HOST_BUILD_DIR) $(GO_HOST_ROOT)
endef

define Host/Clean
	$(call Host/Clean/Default)
	rm -rf $(GO_HOST_ROOT)
endef

$(eval $(call BuildPackage,golang))
$(eval $(call HostBuild))

#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk

PKG_NAME:=dnscrypt-proxy
PKG_VERSION:=2.1.21
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://codeload.github.com/DNSCrypt/$(PKG_NAME)/tar.gz/$(PKG_VERSION)?
PKG_HASH:=8427c2d3c16a0509db89abaebe7a4390014c7e5919290d5dabef8130c5ff7019

PKG_LICENSE:=ISC
PKG_LICENSE_FILES:=LICENSE

# The daemon is built with the host Go toolchain from package/devel/golang
# (the version must satisfy the "go" line of the upstream go.mod). To use a
# different Go, set DNSCRYPT_PROXY_GO=/path/to/go (see README.md in this
# directory).
# All dependencies are vendored by upstream, so no network access is needed
# during the build. The binary is pure Go (CGO_ENABLED=0) and statically
# linked, so it does not depend on the target C library.
# -buildvcs=false keeps Go from stamping the revision of the SDK git checkout
# (the build directory is inside it) into the binary. GOMIPS=softfloat is used
# because the kernel is built without the MIPS FPU emulator.
PKG_BUILD_DEPENDS:=golang/host
DNSCRYPT_PROXY_GO ?= $(STAGING_DIR_HOST)/lib/go/bin/go

ifeq ($(ARCH),aarch64)
  DNSCRYPT_PROXY_GOARCH:=arm64
else ifeq ($(ARCH),mipsel)
  DNSCRYPT_PROXY_GOARCH:=mipsle
  DNSCRYPT_PROXY_GOMIPS:=softfloat
else ifeq ($(ARCH),mips)
  DNSCRYPT_PROXY_GOARCH:=mips
  DNSCRYPT_PROXY_GOMIPS:=softfloat
endif

include $(INCLUDE_DIR)/package.mk

define Package/dnscrypt-proxy
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=IP Addresses and Names
  TITLE:=DNSCrypt, Anonymized DNSCrypt, DoH and Oblivious DoH proxy
  URL:=https://github.com/DNSCrypt/dnscrypt-proxy
  DEPENDS:=+ca-certificates
  DISABLE_RSTRIP:=y
endef

define Package/dnscrypt-proxy/description
  A flexible DNS proxy with support for encrypted DNS protocols: DNSCrypt v2,
  Anonymized DNSCrypt, DNS-over-HTTPS and Oblivious DoH. It listens on a local
  address and forwards queries to the configured upstream servers.
endef

define Package/dnscrypt-proxy/conffiles
/etc/dnscrypt-proxy/dnscrypt-proxy.toml
endef

define Build/Configure
endef

define Build/Compile
	$(if $(DNSCRYPT_PROXY_GOARCH),,$(error dnscrypt-proxy: unsupported architecture '$(ARCH)'))
	@command -v $(DNSCRYPT_PROXY_GO) >/dev/null 2>&1 || { \
		echo "dnscrypt-proxy: Go toolchain '$(DNSCRYPT_PROXY_GO)' was not found." >&2; \
		echo "dnscrypt-proxy: build package/devel/golang first, or set DNSCRYPT_PROXY_GO=/path/to/go." >&2; \
		exit 1; \
	}
	cd $(PKG_BUILD_DIR) && \
		GOOS=linux \
		GOARCH=$(DNSCRYPT_PROXY_GOARCH) \
		$(if $(DNSCRYPT_PROXY_GOMIPS),GOMIPS=$(DNSCRYPT_PROXY_GOMIPS)) \
		CGO_ENABLED=0 \
		GOFLAGS=-mod=vendor \
		GOPROXY=off \
		GOWORK=off \
		GOTOOLCHAIN=local \
		GOCACHE=$(PKG_BUILD_DIR)/.go-cache \
		GOPATH=$(PKG_BUILD_DIR)/.go-path \
		$(DNSCRYPT_PROXY_GO) build -trimpath -buildvcs=false -ldflags '-s -w' \
			-o $(PKG_BUILD_DIR)/dnscrypt-proxy.bin ./dnscrypt-proxy
endef

define Package/dnscrypt-proxy/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/dnscrypt-proxy.bin $(1)/usr/sbin/dnscrypt-proxy
	$(INSTALL_DIR) $(1)/etc/dnscrypt-proxy
	$(INSTALL_DATA) ./files/dnscrypt-proxy.toml $(1)/etc/dnscrypt-proxy/dnscrypt-proxy.toml
endef

$(eval $(call BuildPackage,dnscrypt-proxy))

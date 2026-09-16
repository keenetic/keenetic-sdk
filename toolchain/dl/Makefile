include $(TOPDIR)/rules.mk

PKG_NAME:=dl

PKG_VERSION_REAL:=crosstool-ng-1.27.0-ndm-6
ifeq ($(HOST_ARCH),aarch64)
  PKG_VERSION_REAL:=crosstool-ng-1.27.0-ndm-7
endif
PKG_SOURCE_URL:=https://github.com/keenetic/crosstool-ng/releases/download/$(PKG_VERSION_REAL)

ifeq ($(HOST_ARCH),aarch64)
  ifeq ($(CONFIG_TOOLCHAIN_LIBC),"musl")
    ifeq ($(CONFIG_ARCH),"aarch64")
      PKG_SOURCE:=20260211_2211_toolchain_1.27.0_ndm_7_aarch64-unknown-linux-gnu_aarch64-ndms-linux-musl.tar.xz
      PKG_HASH:=436a55dc9a18562a80c6047f43ed82a666e6e8bb04320044b68c2d596b37a8ff
    else ifeq ($(CONFIG_ARCH),"arm")
      PKG_SOURCE:=20260211_2227_toolchain_1.27.0_ndm_7_aarch64-unknown-linux-gnu_armv7a-ndms-linux-musleabi.tar.xz
      PKG_HASH:=68519aa44e867965383eca8a5d5bad6f07fc8922eac010f8f595ceb8d13f42cd
    else ifeq ($(CONFIG_ARCH),"mips")
      PKG_SOURCE:=20260211_2255_toolchain_1.27.0_ndm_7_aarch64-unknown-linux-gnu_mips-ndms-linux-musl.tar.xz
      PKG_HASH:=95f25206f2f954ea636fe82fd3f4cdae5da22f548d57f20caaf7835346c5999a
    else ifeq ($(CONFIG_ARCH),"mipsel")
      PKG_SOURCE:=20260211_2241_toolchain_1.27.0_ndm_7_aarch64-unknown-linux-gnu_mipsel-ndms-linux-musl.tar.xz
      PKG_HASH:=690353f34bbdc81f0c1417b4ba18abd597d94d704a22cc7fe24a4724de91771a
    endif
  endif
else ifeq ($(HOST_ARCH),x86_64)
  ifeq ($(CONFIG_TOOLCHAIN_LIBC),"glibc")
    ifeq ($(CONFIG_ARCH),"aarch64")
      PKG_SOURCE:=20260206_1549_toolchain_1.27.0_ndm_5.1_05356ea_x86_64-pc-linux-gnu_aarch64-ndms-linux-gnu.tar.xz
      PKG_HASH:=d20aa12125028ca3030400b9c43d7cf8f6b40887b9528156dc73b2b7bc51a158
    endif
  else ifeq ($(CONFIG_TOOLCHAIN_LIBC),"musl")
    ifeq ($(CONFIG_ARCH),"aarch64")
      PKG_SOURCE:=20260206_1607_toolchain_1.27.0_ndm_5.1_05356ea_x86_64-pc-linux-gnu_aarch64-ndms-linux-musl.tar.xz
      PKG_HASH:=27f58c3cfd9ac94438b48f13414aff1cd9530ecbc3635bcaa5c3d030472b501a
    else ifeq ($(CONFIG_ARCH),"arm")
      PKG_SOURCE:=20260206_1625_toolchain_1.27.0_ndm_5.1_05356ea_x86_64-pc-linux-gnu_armv7a-ndms-linux-musleabi.tar.xz
      PKG_HASH:=f2987213592bfd4c2c14ff70f4db18c34404e9c1bd3a651d4b1a6e4bb8587b06
    else ifeq ($(CONFIG_ARCH),"mips")
      PKG_SOURCE:=20260206_1642_toolchain_1.27.0_ndm_5.1_05356ea_x86_64-pc-linux-gnu_mips-ndms-linux-musl.tar.xz
      PKG_HASH:=5eafd09db396b475fd48cfd5b01612a9e2fb7a03902df73188155d70779958dc
    else ifeq ($(CONFIG_ARCH),"mipsel")
      PKG_SOURCE:=20260206_1658_toolchain_1.27.0_ndm_5.1_05356ea_x86_64-pc-linux-gnu_mipsel-ndms-linux-musl.tar.xz
      PKG_HASH:=50eae343123f30097a4c700e5600b5e2d4ca8714c8898791aba34f9288254074
    endif
  endif
endif

include $(INCLUDE_DIR)/toolchain-build.mk
TAR_CMD=$(HOST_TAR) -C $(1) $(TAR_OPTIONS)

define Host/Configure
endef

define Host/Compile
endef

define Host/Install
endef

$(eval $(call HostBuild))

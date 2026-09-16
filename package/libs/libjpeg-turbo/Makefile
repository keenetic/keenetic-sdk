include $(TOPDIR)/rules.mk

PKG_NAME:=libjpeg-turbo
PKG_VERSION:=3.1.1
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://github.com/libjpeg-turbo/libjpeg-turbo/releases/download/$(PKG_VERSION)
PKG_HASH:=aadc97ea91f6ef078b0ae3a62bba69e008d9a7db19b34e4ac973b19b71b4217c

PKG_MAINTAINER:=Rosen Penev <rosenp@gmail.com>
PKG_EPOCH:=1
PKG_LICENSE:=BSD-3-Clause
PKG_LICENSE_FILES:=LICENSE.md
PKG_CPE_ID:=cpe:/a:libjpeg-turbo:libjpeg-turbo

PKG_USE_MIPS16:=0 #Allows ASM compilation for speed.

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/libjpeg-turbo
  SECTION:=libs
  CATEGORY:=Libraries
  TITLE:=libjpeg-turbo
  URL:=https://www.libjpeg-turbo.org/
endef

define Package/libjpeg-turbo/description
	libjpeg-turbo is a speed focused fork of libjpeg.
endef

CMAKE_OPTIONS += \
	-DENABLE_SHARED=OFF \
	-DENABLE_STATIC=ON \
	-DREQUIRE_SIMD=OFF \
	-DWITH_12BIT=OFF \
	-DWITH_ARITH_DEC=OFF \
	-DWITH_ARITH_ENC=OFF \
	-DWITH_JAVA=OFF \
	-DWITH_JPEG7=OFF \
	-DWITH_JPEG8=OFF \
	-DWITH_MEM_SRCDST=OFF \
	-DWITH_SIMD=O$(if $(findstring mips,$(CONFIG_ARCH)),FF,N) \
	-DWITH_TURBOJPEG=OFF \
	-DCMAKE_BUILD_TYPE=Release

ifneq ($(findstring arm,$(CONFIG_ARCH)),)
ifeq ($(findstring neon,$(CONFIG_CPU_TYPE)),)
	CMAKE_OPTIONS += -DWITH_SIMD=OFF
endif
endif

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include
	$(CP) $(PKG_INSTALL_DIR)/usr/include/*.h $(1)/usr/include/
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libjpeg.a $(1)/usr/lib/
endef

$(eval $(call BuildPackage,libjpeg-turbo))

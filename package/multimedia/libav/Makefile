#
# Copyright (C) 2006-2011 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=libav
PKG_VERSION:=v11.7
PKG_RELEASE:=2

PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=$(PKG_VERSION)
PKG_SOURCE_URL:=https://github.com/libav/libav.git

PKG_LICENSE:=LGPL-2.0+ GPL-2.0+

PARSERS_CONFIG=--enable-parser=aac --enable-parser=ac3 --enable-parser=mpegaudio

DEMUXERS_CONFIG=--enable-demuxer=aac --enable-demuxer=ac3 --enable-demuxer=asf --enable-demuxer=vc1 --enable-demuxer=iv8 \
                --enable-demuxer=avi --enable-demuxer=dts --enable-demuxer=eac3 --enable-demuxer=mjpeg --enable-demuxer=vc1t \
                --enable-demuxer=flac --enable-demuxer=flv --enable-demuxer=h264 --enable-demuxer=hevc --enable-demuxer=swf \
                --enable-demuxer=m4v --enable-demuxer=matroska --enable-demuxer=mov --enable-demuxer=flic --enable-demuxer=xwma \
                --enable-demuxer=mp3 --enable-demuxer=mpegps --enable-demuxer=mpegts --enable-demuxer=mv \
                --enable-demuxer=mpegvideo --enable-demuxer=ogg --enable-demuxer=wav --enable-demuxer=mpc --enable-demuxer=mpc8

DECODERS_CONFIG=

PROTOCOLS_CONFIG=--enable-protocol=file

include $(INCLUDE_DIR)/package.mk

define Package/libav
 SECTION:=libs
 CATEGORY:=Libraries
 TITLE:= This package contains Libav library
 URL:=https://libav.org/
endef

define Package/libav/description
 This package contains Libav libraries.
endef

ifeq ($(ARCH),mips)
CONFIGURE_VARS += bigendian=yes
endif

CONFIGURE_ARGS := \
		--pkg-config=$(PKG_CONFIG) \
		--enable-cross-compile \
		--cross-prefix="$(TARGET_CROSS)" \
		--arch="$(ARCH)" \
		--target-os=linux \
		--prefix="/usr" \
		--disable-shared \
		--enable-static \
		--enable-small \
		--enable-pthreads \
		--enable-zlib \
		--disable-runtime-cpudetect \
		--disable-doc \
		--disable-debug \
		--enable-gpl \
		--enable-version3 \
		--disable-avdevice \
		--disable-network \
		--disable-swscale \
		--disable-swscale-alpha \
		--disable-hwaccels \
		--disable-dxva2 \
		--disable-indevs \
		--disable-outdevs \
		--disable-devices \
		--disable-filters \
		--disable-encoders \
		--disable-muxers \
		--disable-decoders \
		--disable-demuxers \
		--disable-parsers \
		--disable-protocols \
		--disable-bsfs \
		\
		--disable-altivec \
		--disable-amd3dnow \
		--disable-amd3dnowext \
		--disable-mmx \
		--disable-mmxext \
		--disable-sse \
		--disable-sse2 \
		--disable-sse3 \
		--disable-ssse3 \
		--disable-sse4 \
		--disable-sse42 \
		--disable-avx \
		--disable-xop \
		--disable-fma3 \
		--disable-fma4 \
		--disable-avx2 \
		--disable-vfp \
		--disable-neon \
		--disable-inline-asm \
		--disable-yasm \
		\
		--disable-vaapi \
		--disable-vda \
		--disable-vdpau \
		\
		--disable-dct \
		--disable-lsp \
		--disable-lzo \
		--disable-mdct \
		--disable-rdft \
		--disable-fft \
		\
		--disable-programs \
		--disable-error-resilience \
		--disable-avresample \
		--disable-swscale \
		--disable-swscale-alpha \
		$(PROTOCOLS_CONFIG) \
		$(PARSERS_CONFIG) \
		$(DECODERS_CONFIG) \
		$(DEMUXERS_CONFIG)

TARGET_CFLAGS += -D_GNU_SOURCE

define Build/Compile
	+$(MAKE) $(PKG_JOBS) -C $(PKG_BUILD_DIR) \
		DESTDIR="$(PKG_INSTALL_DIR)" \
		all
	+$(MAKE) $(PKG_JOBS) -C $(PKG_BUILD_DIR) \
		DESTDIR="$(PKG_INSTALL_DIR)" \
		install
endef

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include
	$(CP) $(PKG_INSTALL_DIR)/usr/include/libav{codec,format,util} $(1)/usr/include/
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libav{codec,format,util}.a $(1)/usr/lib/
endef

$(eval $(call BuildPackage,libav))

#
# Copyright (C) 2009 David Cooper <dave@kupesoft.com>
# Copyright (C) 2006-2010 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

VIDEO_MENU:=Video Support

ifeq ($(strip $(call CompareKernelPatchVer,$(KERNEL_PATCHVER),ge,3.7.0)),1)
V4L2_DIR=v4l2-core
V4L2_USB_DIR=usb
else
V4L2_DIR=video
V4L2_USB_DIR=video
endif


define KernelPackage/fb
  SUBMENU:=$(VIDEO_MENU)
  TITLE:=Framebuffer support
  DEPENDS:=@DISPLAY_SUPPORT
  KCONFIG:=CONFIG_FB
  FILES:= \
	$(LINUX_DIR)/drivers/video/fbdev/core/fb.ko
  AUTOLOAD:=$(call AutoLoad,06,fb)
endef

define KernelPackage/fb/description
  Kernel support for framebuffers
endef

$(eval $(call KernelPackage,fb))

define KernelPackage/fb-cfb-fillrect
  SUBMENU:=$(VIDEO_MENU)
  TITLE:=Framebuffer software rectangle filling support
  DEPENDS:=+kmod-fb
  KCONFIG:=CONFIG_FB_CFB_FILLRECT
  FILES:= \
	$(LINUX_DIR)/drivers/video/fbdev/core/cfbfillrect.ko
  AUTOLOAD:=$(call AutoLoad,07,cfbfillrect)
endef

define KernelPackage/fb-cfb-fillrect/description
  Kernel support for software rectangle filling
endef

$(eval $(call KernelPackage,fb-cfb-fillrect))


define KernelPackage/fb-cfb-copyarea
  SUBMENU:=$(VIDEO_MENU)
  TITLE:=Framebuffer software copy area support
  DEPENDS:=+kmod-fb
  KCONFIG:=CONFIG_FB_CFB_COPYAREA
  FILES:= \
	$(LINUX_DIR)/drivers/video/fbdev/core/cfbcopyarea.ko
  AUTOLOAD:=$(call AutoLoad,07,cfbcopyarea)
endef

define KernelPackage/fb-cfb-copyarea/description
  Kernel support for software copy area
endef

$(eval $(call KernelPackage,fb-cfb-copyarea))

define KernelPackage/fb-cfb-imgblt
  SUBMENU:=$(VIDEO_MENU)
  TITLE:=Framebuffer software image blit support
  DEPENDS:=+kmod-fb
  KCONFIG:=CONFIG_FB_CFB_IMAGEBLIT
  FILES:= \
	$(LINUX_DIR)/drivers/video/fbdev/core/cfbimgblt.ko
  AUTOLOAD:=$(call AutoLoad,07,cfbimgblt)
endef

define KernelPackage/fb-cfb-imgblt/description
  Kernel support for software image blitting
endef

$(eval $(call KernelPackage,fb-cfb-imgblt))


define KernelPackage/media-support
  SUBMENU:=$(VIDEO_MENU)
  TITLE:=Multimedia support
  KCONFIG:= \
	CONFIG_MEDIA_SUPPORT \
	CONFIG_MEDIA_USB_SUPPORT=y
  FILES:=$(wildcard $(LINUX_DIR)/drivers/media/media.ko)
endef

define KernelPackage/media-support/description
  If you want to use Webcams, Video grabber devices and/or TV devices
  enable this option and other options below.
endef

$(eval $(call KernelPackage,media-support))


define KernelPackage/media-digital-tv-support
  SUBMENU:=$(VIDEO_MENU)
  TITLE:=Digital TV support
  DEPENDS:=+kmod-media-support +kmod-i2c-core
  KCONFIG:= \
	CONFIG_FW_LOADER=y \
	CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
  FILES:=$(LINUX_DIR)/drivers/media/dvb-core/dvb-core.ko
endef

define KernelPackage/media-digital-tv-support/description
  Enable digital TV support
endef

$(eval $(call KernelPackage,media-digital-tv-support))


define KernelPackage/media-rc-support
  SUBMENU:=$(VIDEO_MENU)
  TITLE:=Remote Controller support
  DEPENDS:=+kmod-media-support +kmod-input-core
  KCONFIG:= \
	CONFIG_MEDIA_RC_SUPPORT=y \
	CONFIG_RC_DECODERS=n \
	CONFIG_RC_DEVICES=n \
	CONFIG_RC_MAP=n
  FILES:=$(LINUX_DIR)/drivers/media/rc/rc-core.ko
endef

define KernelPackage/media-rc-support/description
  Enable support for Remote Controllers on Linux. This is
  needed in order to support several video capture adapters,
  standalone IR receivers/transmitters, and RF receivers.
endef

$(eval $(call KernelPackage,media-rc-support))


define KernelPackage/dvb-usb
  SUBMENU:=$(VIDEO_MENU)
  TITLE:=Support for various USB DVB devices
  DEPENDS:= \
	+kmod-dvb-frontends \
	+kmod-media-digital-tv-support \
	+kmod-media-rc-support \
	+kmod-usb-core
  KCONFIG:= \
	CONFIG_DVB_USB \
	CONFIG_DVB_USB_CXUSB \
	CONFIG_DVB_USB_DW2102 \
	CONFIG_DVB_USB_AZ6027 \
	CONFIG_DVB_USB_TECHNISAT_USB2
  FILES:= \
	$(LINUX_DIR)/drivers/media/usb/dvb-usb/dvb-usb.ko \
	$(LINUX_DIR)/drivers/media/usb/dvb-usb/dvb-usb-cxusb.ko \
	$(LINUX_DIR)/drivers/media/usb/dvb-usb/dvb-usb-dw2102.ko \
	$(LINUX_DIR)/drivers/media/usb/dvb-usb/dvb-usb-az6027.ko \
	$(LINUX_DIR)/drivers/media/usb/dvb-usb/dvb-usb-technisat-usb2.ko
endef

define KernelPackage/dvb-usb/description
  By enabling this you will be able to choose the various supported
  USB1.1 and USB2.0 DVB devices.
endef

$(eval $(call KernelPackage,dvb-usb))


define KernelPackage/dvb-usb-v2
  SUBMENU:=$(VIDEO_MENU)
  TITLE:=Support for various USB DVB devices v2
  DEPENDS:= \
	+kmod-media-digital-tv-support \
	+kmod-media-rc-support \
	+kmod-usb-core \
	+kmod-i2c-mux
  KCONFIG:= \
	CONFIG_DVB_USB_V2 \
	CONFIG_DVB_USB_RTL28XXU
  FILES:= \
       $(LINUX_DIR)/drivers/media/usb/dvb-usb-v2/dvb_usb_v2.ko \
       $(LINUX_DIR)/drivers/media/usb/dvb-usb-v2/dvb-usb-rtl28xxu.ko
endef

define KernelPackage/dvb-usb-v2/description
  By enabling this you will be able to choose the various supported
  USB1.1 and USB2.0 DVB devices.
endef

$(eval $(call KernelPackage,dvb-usb-v2))


define KernelPackage/media-tuner
  SUBMENU:=$(VIDEO_MENU)
  TITLE:=Media tuner
  DEPENDS:=+kmod-media-digital-tv-support
  KCONFIG:= \
	CONFIG_MEDIA_TUNER_R820T \
	CONFIG_MEDIA_TUNER_SI2157 \
	CONFIG_MEDIA_TUNER_TDA18271
  FILES:= \
	$(LINUX_DIR)/drivers/media/tuners/r820t.ko \
	$(LINUX_DIR)/drivers/media/tuners/si2157.ko \
	$(LINUX_DIR)/drivers/media/tuners/tda18271.ko
endef

$(eval $(call KernelPackage,media-tuner))


define KernelPackage/dvb-frontends
  SUBMENU:=$(VIDEO_MENU)
  TITLE:=DVB Frontends
  DEPENDS:=+kmod-media-digital-tv-support +kmod-i2c-mux +kmod-regmap-i2c
  KCONFIG:= \
	CONFIG_DVB_RTL2832 \
	CONFIG_DVB_MN88473 \
	CONFIG_DVB_CXD2820R \
	CONFIG_DVB_SI2168 \
	CONFIG_DVB_STB0899 \
	CONFIG_DVB_STB6100 \
	CONFIG_DVB_STV090x \
	CONFIG_DVB_STV6110x \
	CONFIG_DVB_TS2020 \
	CONFIG_DVB_M88DS3103 \
	CONFIG_DVB_CX24116
  FILES:= \
	$(LINUX_DIR)/drivers/media/dvb-frontends/rtl2832.ko \
	$(LINUX_DIR)/drivers/media/dvb-frontends/mn88473.ko \
	$(LINUX_DIR)/drivers/media/dvb-frontends/cxd2820r.ko \
	$(LINUX_DIR)/drivers/media/dvb-frontends/si2168.ko \
	$(LINUX_DIR)/drivers/media/dvb-frontends/stb0899.ko \
	$(LINUX_DIR)/drivers/media/dvb-frontends/stb6100.ko \
	$(LINUX_DIR)/drivers/media/dvb-frontends/stv090x.ko \
	$(LINUX_DIR)/drivers/media/dvb-frontends/stv6110x.ko \
	$(LINUX_DIR)/drivers/media/dvb-frontends/ts2020.ko \
	$(LINUX_DIR)/drivers/media/dvb-frontends/m88ds3103.ko \
	$(LINUX_DIR)/drivers/media/dvb-frontends/cx24116.ko
endef

$(eval $(call KernelPackage,dvb-frontends))


define KernelPackage/video-core
  SUBMENU:=$(VIDEO_MENU)
  TITLE=Video4Linux support
  DEPENDS:=@PCI_SUPPORT||USB_SUPPORT +PACKAGE_kmod-i2c-core:kmod-i2c-core +kmod-media-support
  KCONFIG:= \
	CONFIG_MEDIA_CAMERA_SUPPORT=y \
	CONFIG_VIDEO_DEV \
	CONFIG_VIDEO_V4L1=y \
	CONFIG_VIDEO_ALLOW_V4L1=y \
	CONFIG_VIDEO_CAPTURE_DRIVERS=y \
	CONFIG_VIDEO_TVAUDIO=n \
	CONFIG_VIDEO_TDA7432=n \
	CONFIG_VIDEO_TDA9840=n \
	CONFIG_VIDEO_TEA6415C=n \
	CONFIG_VIDEO_TEA6420=n \
	CONFIG_VIDEO_MSP3400=n \
	CONFIG_VIDEO_CS5345=n \
	CONFIG_VIDEO_CS53L32A=n \
	CONFIG_VIDEO_WM8775=n \
	CONFIG_VIDEO_WM8739=n \
	CONFIG_VIDEO_VP27SMPX=n \
	CONFIG_VIDEO_SAA6588=n \
	CONFIG_VIDEO_ADV7180=n \
	CONFIG_VIDEO_ADV7183=n \
	CONFIG_VIDEO_BT819=n \
	CONFIG_VIDEO_BT856=n \
	CONFIG_VIDEO_BT866=n \
	CONFIG_VIDEO_KS0127=n \
	CONFIG_VIDEO_SAA7110=n \
	CONFIG_VIDEO_SAA711X=n \
	CONFIG_VIDEO_SAA7191=n \
	CONFIG_VIDEO_TVP514X=n \
	CONFIG_VIDEO_TVP5150=n \
	CONFIG_VIDEO_TVP7002=n \
	CONFIG_VIDEO_VPX3220=n \
	CONFIG_VIDEO_SAA717X=n \
	CONFIG_VIDEO_CX25840=n \
	CONFIG_VIDEO_CX2341X=n \
	CONFIG_VIDEO_SAA7127=n \
	CONFIG_VIDEO_SAA7185=n \
	CONFIG_VIDEO_ADV7170=n \
	CONFIG_VIDEO_ADV7175=n \
	CONFIG_VIDEO_ADV7343=n \
	CONFIG_VIDEO_AK881X=n \
	CONFIG_VIDEO_OV7670=n \
	CONFIG_VIDEO_VS6624=n \
	CONFIG_VIDEO_MT9V011=n \
	CONFIG_VIDEO_TCM825X=n \
	CONFIG_VIDEO_SR030PC30=n \
	CONFIG_VIDEO_UPD64031A=n \
	CONFIG_VIDEO_UPD64083=n \
	CONFIG_VIDEO_THS7303=n \
	CONFIG_VIDEO_M52790=n \
	CONFIG_VIDEO_PVRUSB2=n \
	CONFIG_VIDEO_EM28XX=n \
	CONFIG_VIDEO_USBVISION=n \
	CONFIG_V4L_USB_DRIVERS=y \
	CONFIG_V4L_PCI_DRIVERS=n \
	CONFIG_V4L_PLATFORM_DRIVERS=n \
	CONFIG_V4L_ISA_PARPORT_DRIVERS=n
  FILES:= \
	$(LINUX_DIR)/drivers/media/$(V4L2_DIR)/v4l2-common.ko \
	$(LINUX_DIR)/drivers/media/$(V4L2_DIR)/videodev.ko
  AUTOLOAD:=$(call AutoLoad,60, videodev v4l2-common)
endef

define KernelPackage/video-core/description
 Kernel modules for Video4Linux support
endef

$(eval $(call KernelPackage,video-core))


define AddDepends/video
  SUBMENU:=$(VIDEO_MENU)
  DEPENDS+=kmod-video-core $(1)
endef

define AddDepends/camera
  SUBMENU:=$(VIDEO_MENU)
  KCONFIG+=CONFIG_MEDIA_USB_SUPPORT=y \
	 CONFIG_MEDIA_CAMERA_SUPPORT=y
  DEPENDS+=kmod-video-core $(1)
endef


define KernelPackage/video-videobuf2
  TITLE:=videobuf2 lib
  KCONFIG:= \
	CONFIG_VIDEOBUF2_CORE \
	CONFIG_VIDEOBUF2_MEMOPS \
	CONFIG_VIDEOBUF2_VMALLOC
  FILES:= \
	$(LINUX_DIR)/drivers/media/$(V4L2_DIR)/videobuf2-core.ko \
	$(LINUX_DIR)/drivers/media/$(V4L2_DIR)/videobuf2-v4l2.ko \
	$(LINUX_DIR)/drivers/media/$(V4L2_DIR)/videobuf2-memops.ko \
	$(LINUX_DIR)/drivers/media/$(V4L2_DIR)/videobuf2-vmalloc.ko
  AUTOLOAD:=$(call AutoLoad,65,videobuf2-core videobuf-v4l2 videobuf2-memops videobuf2-vmalloc)
  $(call AddDepends/video)
endef

define KernelPackage/video-videobuf2/description
 Kernel modules that implements three basic types of media buffers.
endef

$(eval $(call KernelPackage,video-videobuf2))


define KernelPackage/video-cpia2
  TITLE:=CPIA2 video driver
  DEPENDS:=@USB_SUPPORT +kmod-usb-core
  KCONFIG:=CONFIG_VIDEO_CPIA2
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/cpia2/cpia2.ko
  AUTOLOAD:=$(call AutoLoad,70,cpia2)
  $(call AddDepends/camera)
endef

define KernelPackage/video-cpia2/description
 Kernel modules for supporting CPIA2 USB based cameras.
endef

$(eval $(call KernelPackage,video-cpia2))


define KernelPackage/video-sn9c102
  TITLE:=SN9C102 Camera Chip support
  DEPENDS:=@USB_SUPPORT +kmod-usb-core
  KCONFIG:=CONFIG_USB_SN9C102
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/sn9c102/sn9c102.ko
  AUTOLOAD:=$(call AutoLoad,70,gspca_sn9c20x)
  $(call AddDepends/camera)
endef


define KernelPackage/video-sn9c102/description
 Kernel modules for supporting SN9C102
 camera chips.
endef

$(eval $(call KernelPackage,video-sn9c102))


define KernelPackage/video-pwc
  TITLE:=Philips USB webcam support
  DEPENDS:=@USB_SUPPORT +kmod-usb-core +kmod-video-videobuf2
  KCONFIG:= \
	CONFIG_USB_PWC \
	CONFIG_USB_PWC_DEBUG=n
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/pwc/pwc.ko
  AUTOLOAD:=$(call AutoLoad,70,pwc)
  $(call AddDepends/camera)
endef


define KernelPackage/video-pwc/description
 Kernel modules for supporting Philips USB based cameras.
endef

$(eval $(call KernelPackage,video-pwc))

define KernelPackage/video-uvc
  TITLE:=USB Video Class (UVC) support
  DEPENDS:=@USB_SUPPORT +kmod-usb-core +kmod-video-videobuf2
  KCONFIG:= CONFIG_USB_VIDEO_CLASS
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/uvc/uvcvideo.ko
  AUTOLOAD:=$(call AutoLoad,90,uvcvideo)
  $(call AddDepends/camera)
  $(call AddDepends/input)
endef


define KernelPackage/video-uvc/description
 Kernel modules for supporting USB Video Class (UVC) devices.
endef

$(eval $(call KernelPackage,video-uvc))


define KernelPackage/video-gspca-core
  MENU:=1
  TITLE:=GSPCA webcam core support framework
  DEPENDS:=@USB_SUPPORT +kmod-usb-core +kmod-input-core
  KCONFIG:=CONFIG_USB_GSPCA
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_main.ko
  AUTOLOAD:=$(call AutoLoad,70,gspca_main)
  $(call AddDepends/camera)
endef

define KernelPackage/video-gspca-core/description
 Kernel modules for supporting GSPCA based webcam devices. Note this is just
 the core of the driver, please select a submodule that supports your webcam.
endef

$(eval $(call KernelPackage,video-gspca-core))


define AddDepends/camera-gspca
  SUBMENU:=$(VIDEO_MENU)
  DEPENDS+=kmod-video-gspca-core $(1)
endef


define KernelPackage/video-gspca-conex
  TITLE:=conex webcam support
  KCONFIG:=CONFIG_USB_GSPCA_CONEX
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_conex.ko
  AUTOLOAD:=$(call AutoLoad,75,gspca_conex)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-conex/description
 The Conexant Camera Driver (conex) kernel module.
endef

$(eval $(call KernelPackage,video-gspca-conex))


define KernelPackage/video-gspca-etoms
  TITLE:=etoms webcam support
  KCONFIG:=CONFIG_USB_GSPCA_ETOMS
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_etoms.ko
  AUTOLOAD:=$(call AutoLoad,75,gspca_etoms)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-etoms/description
 The Etoms USB Camera Driver (etoms) kernel module.
endef

$(eval $(call KernelPackage,video-gspca-etoms))


define KernelPackage/video-gspca-finepix
  TITLE:=finepix webcam support
  KCONFIG:=CONFIG_USB_GSPCA_FINEPIX
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_finepix.ko
  AUTOLOAD:=$(call AutoLoad,75,gspca_finepix)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-finepix/description
 The Fujifilm FinePix USB V4L2 driver (finepix) kernel module.
endef

$(eval $(call KernelPackage,video-gspca-finepix))


define KernelPackage/video-gspca-mars
  TITLE:=mars webcam support
  KCONFIG:=CONFIG_USB_GSPCA_MARS
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_mars.ko
  AUTOLOAD:=$(call AutoLoad,75,gspca_mars)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-mars/description
 The Mars USB Camera Driver (mars) kernel module.
endef

$(eval $(call KernelPackage,video-gspca-mars))


define KernelPackage/video-gspca-mr97310a
  TITLE:=mr97310a webcam support
  KCONFIG:=CONFIG_USB_GSPCA_MR97310A
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_mr97310a.ko
  AUTOLOAD:=$(call AutoLoad,75,gspca_mr97310a)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-mr97310a/description
 The Mars-Semi MR97310A USB Camera Driver (mr97310a) kernel module.
endef

$(eval $(call KernelPackage,video-gspca-mr97310a))


define KernelPackage/video-gspca-ov519
  TITLE:=ov519 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_OV519
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_ov519.ko
  AUTOLOAD:=$(call AutoLoad,75,gspca_ov519)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-ov519/description
 The OV519 USB Camera Driver (ov519) kernel module.
endef

$(eval $(call KernelPackage,video-gspca-ov519))


define KernelPackage/video-gspca-ov534
  TITLE:=ov534 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_OV534
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_ov534.ko
  AUTOLOAD:=$(call AutoLoad,75,gspca_ov534)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-ov534/description
 The OV534 USB Camera Driver (ov534) kernel module.
endef

$(eval $(call KernelPackage,video-gspca-ov534))


define KernelPackage/video-gspca-ov534-9
  TITLE:=ov534-9 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_OV534_9
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_ov534_9.ko
  AUTOLOAD:=$(call AutoLoad,75,gspca_ov534_9)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-ov534-9/description
 The OV534-9 USB Camera Driver (ov534_9) kernel module.
endef

$(eval $(call KernelPackage,video-gspca-ov534-9))


define KernelPackage/video-gspca-pac207
  TITLE:=pac207 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_PAC207 CONFIG_USB_GSPCA_PAC7302
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_pac207.ko \
    $(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_pac7302.ko
  AUTOLOAD:=$(call AutoLoad,75,gspca_pac207)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-pac207/description
 The Pixart PAC207 USB Camera Driver (pac207) kernel module.
endef

$(eval $(call KernelPackage,video-gspca-pac207))


define KernelPackage/video-gspca-pac7311
  TITLE:=pac7311 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_PAC7311
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_pac7311.ko
  AUTOLOAD:=$(call AutoLoad,75,gspca_pac7311)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-pac7311/description
 The Pixart PAC7311 USB Camera Driver (pac7311) kernel module.
endef

$(eval $(call KernelPackage,video-gspca-pac7311))


define KernelPackage/video-gspca-se401
  TITLE:=se401 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_SE401
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_se401.ko
  AUTOLOAD:=$(call AutoLoad,75,gspca_se401)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-se401/description
 The SE401 USB Camera Driver kernel module.
endef

$(eval $(call KernelPackage,video-gspca-se401))


define KernelPackage/video-gspca-sn9c20x
  TITLE:=sn9c20x webcam support
  KCONFIG:=CONFIG_USB_GSPCA_SN9C20X
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_sn9c20x.ko
  AUTOLOAD:=$(call AutoLoad,75,gspca_sn9c20x)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-sn9c20x/description
 The SN9C20X USB Camera Driver (sn9c20x) kernel module.
endef

$(eval $(call KernelPackage,video-gspca-sn9c20x))


define KernelPackage/video-gspca-sonixb
  TITLE:=sonixb webcam support
  KCONFIG:=CONFIG_USB_GSPCA_SONIXB
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_sonixb.ko
  AUTOLOAD:=$(call AutoLoad,75,gspca_sonixb)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-sonixb/description
 The SONIX Bayer USB Camera Driver (sonixb) kernel module.
endef

$(eval $(call KernelPackage,video-gspca-sonixb))


define KernelPackage/video-gspca-sonixj
  TITLE:=sonixj webcam support
  KCONFIG:=CONFIG_USB_GSPCA_SONIXJ
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_sonixj.ko
  AUTOLOAD:=$(call AutoLoad,75,gspca_sonixj)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-sonixj/description
 The SONIX JPEG USB Camera Driver (sonixj) kernel module.
endef

$(eval $(call KernelPackage,video-gspca-sonixj))

define KernelPackage/video-gspca-sn9c2028
  TITLE:=sn9c2028 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_SN9C2028
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_sn9c2028.ko
  AUTOLOAD:=$(call AutoLoad,75,gspca_sn9c2028)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-sn9c2028/description
 The USB Camera Driver (sn9c2028) kernel module.
endef

$(eval $(call KernelPackage,video-gspca-sn9c2028))


define KernelPackage/video-gspca-spca500
  TITLE:=spca500 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_SPCA500
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_spca500.ko
  AUTOLOAD:=$(call AutoLoad,75,gspca_spca500)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-spca500/description
 The SPCA500 USB Camera Driver (spca500) kernel module.
endef

$(eval $(call KernelPackage,video-gspca-spca500))


define KernelPackage/video-gspca-spca501
  TITLE:=spca501 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_SPCA501
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_spca501.ko
  AUTOLOAD:=$(call AutoLoad,75,gspca_spca501)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-spca501/description
 The SPCA501 USB Camera Driver (spca501) kernel module.
endef

$(eval $(call KernelPackage,video-gspca-spca501))


define KernelPackage/video-gspca-spca505
  TITLE:=spca505 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_SPCA505
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_spca505.ko
  AUTOLOAD:=$(call AutoLoad,75,gspca_spca505)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-spca505/description
 The SPCA505 USB Camera Driver (spca505) kernel module.
endef

$(eval $(call KernelPackage,video-gspca-spca505))


define KernelPackage/video-gspca-spca506
  TITLE:=spca506 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_SPCA506
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_spca506.ko
  AUTOLOAD:=$(call AutoLoad,75,gspca_spca506)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-spca506/description
 The SPCA506 USB Camera Driver (spca506) kernel module.
endef

$(eval $(call KernelPackage,video-gspca-spca506))


define KernelPackage/video-gspca-spca508
  TITLE:=spca508 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_SPCA508
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_spca508.ko
  AUTOLOAD:=$(call AutoLoad,75,gspca_spca508)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-spca508/description
 The SPCA508 USB Camera Driver (spca508) kernel module.
endef

$(eval $(call KernelPackage,video-gspca-spca508))


define KernelPackage/video-gspca-spca561
  TITLE:=spca561 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_SPCA561
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_spca561.ko
  AUTOLOAD:=$(call AutoLoad,75,gspca_spca561)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-spca561/description
 The SPCA561 USB Camera Driver (spca561) kernel module.
endef

$(eval $(call KernelPackage,video-gspca-spca561))


define KernelPackage/video-gspca-spca1528
  TITLE:=spca1528 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_SPCA1528
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_spca1528.ko
  AUTOLOAD:=$(call AutoLoad,75,gspca_spca1528)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-spca1528/description
 The USB Camera Driver (spca1528) kernel module.
endef

$(eval $(call KernelPackage,video-gspca-spca1528))

define KernelPackage/video-gspca-sq905
  TITLE:=sq905 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_SQ905
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_sq905.ko
  AUTOLOAD:=$(call AutoLoad,75,gspca_sq905)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-sq905/description
 The SQ Technologies SQ905 based USB Camera Driver (sq905) kernel module.
endef

$(eval $(call KernelPackage,video-gspca-sq905))


define KernelPackage/video-gspca-sq905c
  TITLE:=sq905c webcam support
  KCONFIG:=CONFIG_USB_GSPCA_SQ905C
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_sq905c.ko
  AUTOLOAD:=$(call AutoLoad,75,gspca_sq905c)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-sq905c/description
 The SQ Technologies SQ905C based USB Camera Driver (sq905c) kernel module.
endef

$(eval $(call KernelPackage,video-gspca-sq905c))


define KernelPackage/video-gspca-sq930x
  TITLE:=sq930x webcam support
  KCONFIG:=CONFIG_USB_GSPCA_SQ930X
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_sq930x.ko
  AUTOLOAD:=$(call AutoLoad,75,gspca_sq930x)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-sq930x/description
 The SQ Technologies sq930x based USB Camera Driver (sq930x) kernel module.
endef

$(eval $(call KernelPackage,video-gspca-sq930x))

define KernelPackage/video-gspca-stk014
  TITLE:=stk014 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_STK014
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_stk014.ko
  AUTOLOAD:=$(call AutoLoad,75,gspca_stk014)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-stk014/description
 The Syntek DV4000 (STK014) USB Camera Driver (stk014) kernel module.
endef

$(eval $(call KernelPackage,video-gspca-stk014))

define KernelPackage/video-gspca-stk1135
  TITLE:=stk1135 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_STK1135
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_stk1135.ko
  AUTOLOAD:=$(call AutoLoad,75,gspca_stk1135)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-stk1135/description
 The USB Camera Driver (stk1135) kernel module.
endef

$(eval $(call KernelPackage,video-gspca-stk1135))


define KernelPackage/video-gspca-sunplus
  TITLE:=sunplus webcam support
  KCONFIG:=CONFIG_USB_GSPCA_SUNPLUS
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_sunplus.ko
  AUTOLOAD:=$(call AutoLoad,75,gspca_sunplus)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-sunplus/description
 The SUNPLUS USB Camera Driver (sunplus) kernel module.
endef

$(eval $(call KernelPackage,video-gspca-sunplus))


define KernelPackage/video-gspca-t613
  TITLE:=t613 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_T613
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_t613.ko
  AUTOLOAD:=$(call AutoLoad,75,gspca_t613)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-t613/description
 The T613 (JPEG Compliance) USB Camera Driver (t613) kernel module.
endef

$(eval $(call KernelPackage,video-gspca-t613))


define KernelPackage/video-gspca-tv8532
  TITLE:=tv8532 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_TV8532
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_tv8532.ko
  AUTOLOAD:=$(call AutoLoad,75,gspca_tv8532)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-tv8532/description
 The TV8532 USB Camera Driver (tv8532) kernel module.
endef

$(eval $(call KernelPackage,video-gspca-tv8532))


define KernelPackage/video-gspca-vc032x
  TITLE:=vc032x webcam support
  KCONFIG:=CONFIG_USB_GSPCA_VC032X
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_vc032x.ko
  AUTOLOAD:=$(call AutoLoad,75,gspca_vc032x)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-vc032x/description
 The VC032X USB Camera Driver (vc032x) kernel module.
endef

$(eval $(call KernelPackage,video-gspca-vc032x))


define KernelPackage/video-gspca-zc3xx
  TITLE:=zc3xx webcam support
  KCONFIG:=CONFIG_USB_GSPCA_ZC3XX
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_zc3xx.ko
  AUTOLOAD:=$(call AutoLoad,75,gspca_zc3xx)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-zc3xx/description
 The ZC3XX USB Camera Driver (zc3xx) kernel module.
endef

$(eval $(call KernelPackage,video-gspca-zc3xx))


define KernelPackage/video-gspca-m5602
  TITLE:=m5602 webcam support
  KCONFIG:=CONFIG_USB_M5602
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/m5602/gspca_m5602.ko
  AUTOLOAD:=$(call AutoLoad,75,gspca_m5602)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-m5602/description
 The ALi USB m5602 Camera Driver (m5602) kernel module.
endef

$(eval $(call KernelPackage,video-gspca-m5602))


define KernelPackage/video-gspca-stv06xx
  TITLE:=stv06xx webcam support
  KCONFIG:=CONFIG_USB_STV06XX
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/stv06xx/gspca_stv06xx.ko
  AUTOLOAD:=$(call AutoLoad,75,gspca_stv06xx)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-stv06xx/description
 The STV06XX USB Camera Driver (stv06xx) kernel module.
endef

$(eval $(call KernelPackage,video-gspca-stv06xx))


define KernelPackage/video-gspca-gl860
  TITLE:=gl860 webcam support
  KCONFIG:=CONFIG_USB_GL860
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gl860/gspca_gl860.ko
  AUTOLOAD:=$(call AutoLoad,75,gspca_gl860)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-gl800/description
 The GL860 USB Camera Driver (gl860) kernel module.
endef

$(eval $(call KernelPackage,video-gspca-gl860))


define KernelPackage/video-gspca-jeilinj
  TITLE:=jeilinj webcam support
  KCONFIG:=CONFIG_USB_GSPCA_JEILINJ
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_jeilinj.ko
  AUTOLOAD:=$(call AutoLoad,75,gspca_jeilinj)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-jeilinj/description
 The JEILINJ USB Camera Driver (jeilinj) kernel module.
endef

$(eval $(call KernelPackage,video-gspca-jeilinj))


define KernelPackage/video-gspca-konica
  TITLE:=konica webcam support
  KCONFIG:=CONFIG_USB_GSPCA_KONICA
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_konica.ko
  AUTOLOAD:=$(call AutoLoad,75,gspca_konica)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-konica/description
 The Konica USB Camera Driver (konica) kernel module.
endef

$(eval $(call KernelPackage,video-gspca-konica))


define KernelPackage/video-gspca-benq
  TITLE:=benq webcam support
  KCONFIG:=CONFIG_USB_GSPCA_BENQ
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_benq.ko
  AUTOLOAD:=$(call AutoLoad,75,gspca_benq)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-benq/description
 The USB Camera Driver (benq) kernel module.
endef

$(eval $(call KernelPackage,video-gspca-benq))

define KernelPackage/video-gspca-cpia1
  TITLE:=cpia1 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_CPIA1
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_cpia1.ko
  AUTOLOAD:=$(call AutoLoad,75,gspca_cpia1)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-cpia1/description
 The USB Camera Driver (cpia1) kernel module.
endef

$(eval $(call KernelPackage,video-gspca-cpia1))

define KernelPackage/video-gspca-dtcs033
  TITLE:=dtcs033 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_DTCS033
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_dtcs033.ko
  AUTOLOAD:=$(call AutoLoad,75,gspca_dtcs033)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-dtcs033/description
 The USB Camera Driver (dtcs033) kernel module.
endef

$(eval $(call KernelPackage,video-gspca-dtcs033))

define KernelPackage/video-gspca-jl2005bcd
  TITLE:=jl2005bcd webcam support
  KCONFIG:=CONFIG_USB_GSPCA_JL2005BCD
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_jl2005bcd.ko
  AUTOLOAD:=$(call AutoLoad,75,gspca_jl2005bcd)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-jl2005bcd/description
 The USB Camera Driver (jl2005bcd) kernel module.
endef

$(eval $(call KernelPackage,video-gspca-jl2005bcd))

define KernelPackage/video-gspca-kinect
  TITLE:=kinect webcam support
  KCONFIG:=CONFIG_USB_GSPCA_KINECT
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_kinect.ko
  AUTOLOAD:=$(call AutoLoad,75,gspca_kinect)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-kinect/description
 The USB Camera Driver (kinect) kernel module.
endef

$(eval $(call KernelPackage,video-gspca-kinect))

define KernelPackage/video-gspca-nw80x
  TITLE:=nw80x webcam support
  KCONFIG:=CONFIG_USB_GSPCA_NW80X
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_nw80x.ko
  AUTOLOAD:=$(call AutoLoad,75,gspca_nw80x)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-nw80x/description
 The USB Camera Driver (nw80x) kernel module.
endef

$(eval $(call KernelPackage,video-gspca-nw80x))

define KernelPackage/video-gspca-stv0680
  TITLE:=stv0680 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_STV0680
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_stv0680.ko
  AUTOLOAD:=$(call AutoLoad,75,gspca_stv0680)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-stv0680/description
 The USB Camera Driver (stv0680) kernel module.
endef

$(eval $(call KernelPackage,video-gspca-stv0680))

define KernelPackage/video-gspca-topro
  TITLE:=topro webcam support
  KCONFIG:=CONFIG_USB_GSPCA_TOPRO
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_topro.ko
  AUTOLOAD:=$(call AutoLoad,75,gspca_topro)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-topro/description
 The USB Camera Driver (topro) kernel module.
endef

$(eval $(call KernelPackage,video-gspca-topro))

define KernelPackage/video-gspca-toputek
  TITLE:=toputek webcam support
  KCONFIG:=CONFIG_USB_GSPCA_TOUPTEK
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_toputek.ko
  AUTOLOAD:=$(call AutoLoad,75,gspca_toputek)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-toputek/description
 The USB Camera Driver (toputek) kernel module.
endef

$(eval $(call KernelPackage,video-gspca-toputek))

define KernelPackage/video-gspca-vicam
  TITLE:=vicam webcam support
  KCONFIG:=CONFIG_USB_GSPCA_VICAM
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_vicam.ko
  AUTOLOAD:=$(call AutoLoad,75,gspca_vicam)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-vicam/description
 The USB Camera Driver (vicam) kernel module.
endef

$(eval $(call KernelPackage,video-gspca-vicam))

define KernelPackage/video-gspca-xirlink-cit
  TITLE:=xirlink-cit webcam support
  KCONFIG:=CONFIG_USB_GSPCA_XIRLINK_CIT
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_xilink_cit.ko
  AUTOLOAD:=$(call AutoLoad,75,gspca_xirlink_cit)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-xirlink-cit/description
 The USB Camera Driver (xirlink-cit) kernel module.
endef

$(eval $(call KernelPackage,video-gspca-xirlink-cit))

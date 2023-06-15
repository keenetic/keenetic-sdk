include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/image.mk

KERNEL_LOADADDR := 0x41080000

ifdef IB
  define Build/build-dtb
	@true
  endef
else
  define Build/build-dtb
	$(call Image/BuildDTB,../dts/$(1).dts,$@.dtb)
  endef
endif

define Device/Default
  BLOCKSIZE := $(call qstrip,$(CONFIG_TARGET_MTD_BLOCK_SIZE))
  IMAGE_SIZE := $(call qstrip,$(CONFIG_TARGET_FIRMWARE_SIZE))
  KERNEL = \
	kernel-bin | lzma | \
	build-dtb $(1) | \
	fit lzma $(KDIR)/$$(KERNEL_IMAGE).dtb | \
	pad-to $$(BLOCKSIZE)
  IMAGES := fw.bin
  IMAGE/fw.bin = \
	append-kernel | ndmfw-pad $$$$(BLOCKSIZE) | \
	append-rootfs $$$$(BLOCKSIZE) | \
	check-size Firmware $$$$(BLOCKSIZE) $$$$(IMAGE_SIZE) | \
	ndmfw-mark $$$$(BLOCKSIZE) | ndmfw-sign $$$$(BLOCKSIZE) | \
	ndmfw-dump $$$$(BLOCKSIZE) | log-size
  IMAGE_NAME = $(NDM_FIRMWARE_FNAME)
endef

ifeq ($(SUBTARGET),KN-1811)
  TARGET_DEVICES += KN-1811
endif

ifeq ($(SUBTARGET),KN-2710)
  TARGET_DEVICES += KN-2710
endif

ifeq ($(SUBTARGET),KN-2701)
  TARGET_DEVICES += KN-2701
endif

ifeq ($(SUBTARGET),ZN-1811)
  TARGET_DEVICES += ZN-1811
endif

$(eval $(call BuildImage))

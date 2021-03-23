#
# Copyright (C) 2021 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

MTD_BLOCK_SIZE = $(call qstrip,$(CONFIG_TARGET_MTD_BLOCK_SIZE))
TLV_BLOCK_SIZE = $(if $(CONFIG_TARGET_SIGN_FIRMWARE),$(MTD_BLOCK_SIZE),0x0)
TLV_BLOCK_SCMD = stat -c%s $(KERNEL_FILE)
KERNEL_IMG     = $(PACKAGE_DIR)/kernel-$(ARCH_PACKAGES)-$(LINUX_VERSION)-$(LINUX_RELEASE).img
KERNEL_SIZE    = $(shell echo $$(($(call qstrip,$(CONFIG_TARGET_KERNEL_SIZE))-$(TLV_BLOCK_SIZE))))
KERNEL_FILE    = $(LINUX_DIR)/vmlinux.bin.img
ROOTFS_SIZE    = $(call qstrip,$(CONFIG_TARGET_ROOTFS_SIZE))
FIRMWARE_SIZE  = $(call qstrip,$(CONFIG_TARGET_FIRMWARE_SIZE))
FIRMWARE_FILE  = $(BIN_DIR)/$(NDM_FIRMWARE_FNAME)
SIZE_FILE      = $(BUILD_LOG_DIR)/sizes/$(NDM_FIRMWARE_SIZE_FNAME)
FIRMWARE_DESC  = $(shell echo $(call qstrip,$(CONFIG_TARGET_ARCH_PACKAGES)) '$(NDM_FIRMWARE_VERSION)')
FW_COMPONENTS  = $(subst $(space),$(comma),$(sort $(NDM_PACKAGES)))

ifneq ($(wildcard $(STAGING_DIR_HOST)/bin/ndmfw),)
  NDMFW_MARK   = ndmfw mark \
	$(if $(CONFIG_TARGET_SIGN_FIRMWARE) \
		, -O $$$$($(TLV_BLOCK_SCMD)) \
		  -B $(TLV_BLOCK_SIZE) \
		  -D $(TARGET_CA_CERTS_SIGN_DIR) \
		  -N $(CONFIG_TARGET_SIGN_TYPE) \
		  -T "        firmware_id: $(call qstrip,$(CONFIG_TARGET_DEVICE_ID))" \
		  -T "        hardware_id: $(call qstrip,$(CONFIG_TARGET_ARCH_PACKAGES))" \
		  -T "           customer: $(call qstrip,$(CONFIG_TARGET_CUSTOMER))" \
		  -T "device_manufacturer: $(call qstrip,$(CONFIG_TARGET_DEVICE_MANUFACTURER))" \
		  -T "       model_series: $(call qstrip,$(CONFIG_TARGET_MODEL_SERIES))" \
		  -T "             vendor: $(call qstrip,$(CONFIG_TARGET_VENDOR))" \
		  -T "       vendor_email: $(call qstrip,$(CONFIG_TARGET_VENDOR_EMAIL))" \
		  -T "       vendor_short: $(call qstrip,$(CONFIG_TARGET_VENDOR_SHORT))" \
		  -T "         vendor_url: $(call qstrip,$(CONFIG_TARGET_VENDOR_URL))" \
		  -T "            version: $(call qstrip,$(NDM_FIRMWARE_VERSION))" \
		  -T "         components: $(call qstrip,$(FW_COMPONENTS))" \
	 ) \
	-v "$(FIRMWARE_DESC)" \
	-f $(CONFIG_TARGET_DEVICE_ID) \
	$(FIRMWARE_FILE)

  NDMFW_SIGN   = \
	$(if $(shell if [ -f "$(BUILDER_KEY)" ] && [ -f "$(BUILDER_CRT)" ]; then echo 1; fi) \
		, ndmfw sign \
			-B $(TLV_BLOCK_SIZE) \
			-K "$(BUILDER_KEY)" \
			-C "$(BUILDER_CRT)" \
			$(FIRMWARE_FILE) \
		, $(if $(BUILD_PACKAGES), echo "Please setup certificate and key."; false, true) \
	 )

  NDMFW_DUMP   = ndmfw dump \
	-B $(TLV_BLOCK_SIZE) \
	-D "$(TARGET_CA_CERTS_SIGN_DIR)" \
	$(FIRMWARE_FILE)
else
  NDMFW_MARK     = zyimage \
	-d $(CONFIG_TARGET_DEVICE_ID) \
	-v "$(FIRMWARE_DESC)" \
	$(FIRMWARE_FILE)
  NDMFW_SIGN     = true
  NDMFW_DUMP     = true
endif

define MkImage
	mkimage -A mips -O linux -T kernel -C $(1) \
		-a `LC_ALL=C readelf -e $(KERNEL_BUILD_DIR)/vmlinux.elf 2>/dev/null | grep "\[ 1\]"| head -1 | cut -d" " -f 26` \
		-e `LC_ALL=C readelf -h $(KERNEL_BUILD_DIR)/vmlinux.elf 2>/dev/null | grep 'Entry' | awk '{print $$$$4}'` \
		-n "$(shell echo $(call qstrip,$(CONFIG_TARGET_ARCH_PACKAGES)))" \
		-d $(2) $(if $(CONFIG_KERNEL_MTD_NDM_DUAL_IMAGE),-g) $(3)
endef

define CheckSize
	if [ "$$$$(($(3) % $(MTD_BLOCK_SIZE)))" -ne "0" ]; then \
		printf "\n$(1) size (0x%08x) is not a multiple of a MTD block size (0x%08x)!\n\n" "$(3)" "$(MTD_BLOCK_SIZE)"; \
		false; \
	elif [ ! -f $(2) ]; then \
		printf "\nNo $(2) file found."; \
		false; \
	else \
		SIZE=`stat -c%s $(2)`; \
		if [ "$$$${SIZE}" -gt "$$$$(($(3)))" ]; then \
			printf "\n$(1) size limit (0x%08x) exceeded! Need more $$$$(($$$${SIZE} - $(3))) bytes!\n\n" "$(3)"; \
			false; \
		fi; \
	fi
endef

define AlignToBlock
	if [ ! -f $(1) ]; then \
		printf "\nNo $(1) file found.\n\n"; \
		false; \
	else \
		SIZE=`stat -c%s $(1)`; \
		RESIDUE=$$$$(($$$${SIZE} % $(2))); \
		if [ "$$$${RESIDUE}" -ne "0" ]; then \
			SIZE=$$$$(($$$${SIZE} + $(2) - $$$${RESIDUE})); \
		fi; \
		dd \
			if=/dev/zero \
			bs=$$$${SIZE} \
			count=1 \
			conv=sync | tr "\000" "\377" > $(1).ffpad; \
		dd \
			if=$(1) \
			of=$(1).ffpad \
			bs=$$$$(($(MTD_BLOCK_SIZE))) \
			conv=notrunc; \
		mv $(1).ffpad $(1); \
	fi
endef

define Image/Build
	echo "$(NDM_FIRMWARE_VERSION)" > $(TMP_DIR)/version
  ifneq ($(CONFIG_KERNEL_IMAGE_CMDLINE_HACK),)
	$(STAGING_DIR_HOST)/bin/patch-cmdline \
		$(LINUX_KERNEL) \
		"console=$(call qstrip,$(CONFIG_TARGET_DEV_CONSOLE)),57600n8 rdinit=/sbin/init"
  endif
	$(STAGING_DIR_HOST)/bin/lzma e $(LINUX_KERNEL) -lc1 -lp2 -pb2 -mt$(N_CPU) $(LINUX_DIR)/vmlinux.bin.lzma
	$(call MkImage,lzma,$(LINUX_DIR)/vmlinux.bin.lzma,$(KERNEL_FILE))
	$(call AlignToBlock,$(KERNEL_FILE),$$$$(($(MTD_BLOCK_SIZE))))
	#
	# KERNEL_FILE - kernel image aligned by a block size; a file size
	#               should not be changed to correctly get a TLV block offset
	#               later with TLV_BLOCK_SCMD.
	#
	$(CP) $(KERNEL_FILE) $(KERNEL_IMG)
	#
	# Log sizes of kernel & root FS.
	#
	mkdir -p $$$$(dirname $(SIZE_FILE))
	( \
		echo "Kernel:"; \
		cd $(LINUX_DIR) && stat --printf="%-20n %s\n" vmlinux*; \
		echo; \
		echo "Root FS:"; \
		cd $(KDIR) && stat --printf="%-20n %s\n" root.$(1); \
		echo; \
		cd $(TARGET_DIR) && du --all --bytes | sort --key=2 | LC_ALL=C.UTF-8 column -t; \
	) > $(SIZE_FILE)
  ifneq ($(CONFIG_TARGET_SIGN_FIRMWARE),)
	#
	# Reserve a TLV table block.
	#
	$(call AlignToBlock,$(KERNEL_IMG),$$$$(($$$$($(TLV_BLOCK_SCMD))+$(TLV_BLOCK_SIZE))))
  endif
  ifneq ($(CONFIG_TARGET_SPLIT_FIRMWARE_SIZE),)
	#
	# Check kernel and image sizes before alignments.
	#
	$(call CheckSize,Kernel,$(KERNEL_IMG),$(KERNEL_SIZE))
	$(call CheckSize,Firmware,$(KDIR)/root.$(1),$(ROOTFS_SIZE))
	$(call AlignToBlock,$(KERNEL_IMG),$$$$(($(KERNEL_SIZE))))
  endif
	$(call AlignToBlock,$(KDIR)/root.$(1),$$$$(($(MTD_BLOCK_SIZE))))
	#
	# Merge prepared kernel and root FS images.
	#
	dd \
		if=$(KERNEL_IMG) \
		of=$(FIRMWARE_FILE) \
		bs=$$$$(($(MTD_BLOCK_SIZE)))
	dd \
		if=$(KDIR)/root.$(1) \
		of=$(FIRMWARE_FILE) \
		bs=$$$$(($(MTD_BLOCK_SIZE))) \
		oflag=append \
		conv=notrunc
  ifeq ($(CONFIG_TARGET_SPLIT_FIRMWARE_SIZE),)
	#
	# Check a size of a whole output image.
	#
	$(call CheckSize,Firmware,$(FIRMWARE_FILE),$(FIRMWARE_SIZE))
  endif
	#
	# Mark a firmware image.
	#
	$(if $(CONFIG_TARGET_SIGN_FIRMWARE) \
		, $(NDMFW_MARK) && $(NDMFW_SIGN) && $(NDMFW_DUMP) \
		, $(NDMFW_MARK))
endef

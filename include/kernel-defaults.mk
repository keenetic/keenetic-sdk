#
# Copyright (C) 2006-2015 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

ifeq ($(strip $(CONFIG_KERNEL_GIT_CLONE_CUSTOM_URI)),y)
  KERNEL_GIT_CLONE_URI:=$(strip $(patsubst "%",%,$(CONFIG_KERNEL_GIT_CLONE_URI)))
  KERNEL_GIT_REVISION:=$(or $(strip $(patsubst "%",%,$(CONFIG_KERNEL_GIT_REVISION))),"master")
else ifeq ($(strip $(KERNEL_PATCHVER)),4.9)
  KERNEL_49_SOURCE_URL:=$(NDM_STORAGE)/kernel-49
  KERNEL_49_SOURCE_VERSION:=4.9.330-0-20
  KERNEL_GIT_CLONE_URI:=$(KERNEL_49_SOURCE_URL)
  KERNEL_GIT_REVISION:=$(KERNEL_49_SOURCE_VERSION)
else ifeq ($(DUMP),)
  $(error Unknown LINUX_VERSION=$(LINUX_VERSION))
endif

ifdef CONFIG_STRIP_KERNEL_EXPORTS
  KERNEL_MAKEOPTS_EXPORTS := \
	EXTRA_LDSFLAGS="-I$(KERNEL_BUILD_DIR) -include symtab.h"
endif

INITRAMFS_EXTRA_FILES ?= $(GENERIC_PLATFORM_DIR)/image/initramfs-base-files.txt

FIRMWARE_VERSION = $(shell echo $(CONFIG_TARGET_VERSION) | \
	sed -e 's/~e/$(BSP_EPOCH)/g' \
	    -e 's/~j/$(BSP_MAJOR)/g' \
	    -e 's/~n/$(BSP_MINOR)/g' \
	    -e 's/~s/$(BSP_STAGE)/g' \
	    -e 's/~b/$(BSP_BUILD)/g' \
	    -e 's/~t/$(BSP_MAINT)/g')

TARGET_CFLAGS := -D__TARGET_VERSION__=\"\\\"$(FIRMWARE_VERSION)\\\"\" -D__TARGET_BOARD__=\"\\\"$(CONFIG_TARGET_ARCH_PACKAGES)\\\"\"

KERNEL_MAKEOPTS += CFLAGS_MODULE+="$(TARGET_CFLAGS)"

ifneq (,$(KERNEL_CC))
  KERNEL_MAKEOPTS += CC="$(KERNEL_CC)"
endif

export HOST_EXTRACFLAGS=-I$(STAGING_DIR_HOST)/include

# defined in quilt.mk
Kernel/Patch:=$(Kernel/Patch/Default)

define Kernel/Prepare/Default
	$(call target/linux/prepare)
	mkdir -p $(LINUX_DIR)
	zstdcat $(DL_DIR)/linux-$(KERNEL_GIT_REVISION).tar.zst | $(TAR) -C $(LINUX_DIR) $(TAR_OPTIONS) --strip-components=1
	$(Kernel/Patch)
	touch $(LINUX_DIR)/.quilt_used
endef

ifeq ($(CONFIG_TARGET_ROOTFS_INITRAMFS),y)
  ifeq ($(strip $(CONFIG_EXTERNAL_CPIO)),"")
    define Kernel/SetInitramfs
		rm -f $(LINUX_DIR)/.config.prev
		mv $(LINUX_DIR)/.config $(LINUX_DIR)/.config.old
		grep -v -e INITRAMFS -e CONFIG_RD_ -e CONFIG_BLK_DEV_INITRD $(LINUX_DIR)/.config.old > $(LINUX_DIR)/.config
		echo 'CONFIG_BLK_DEV_INITRD=y' >> $(LINUX_DIR)/.config
		echo 'CONFIG_INITRAMFS_SOURCE="$(strip $(TARGET_DIR) $(INITRAMFS_EXTRA_FILES))"' >> $(LINUX_DIR)/.config
		echo 'CONFIG_INITRAMFS_ROOT_UID=$(shell id -u)' >> $(LINUX_DIR)/.config
		echo 'CONFIG_INITRAMFS_ROOT_GID=$(shell id -g)' >> $(LINUX_DIR)/.config
		echo "$(if $(CONFIG_TARGET_INITRAMFS_COMPRESSION_NONE),CONFIG_INITRAMFS_COMPRESSION_NONE=y,# CONFIG_INITRAMFS_COMPRESSION_NONE is not set)" >> $(LINUX_DIR)/.config
		echo -e "$(if $(CONFIG_TARGET_INITRAMFS_COMPRESSION_GZIP),CONFIG_INITRAMFS_COMPRESSION_GZIP=y\nCONFIG_RD_GZIP=y,# CONFIG_INITRAMFS_COMPRESSION_GZIP is not set\n# CONFIG_RD_GZIP is not set)" >> $(LINUX_DIR)/.config
		echo -e "$(if $(CONFIG_TARGET_INITRAMFS_COMPRESSION_BZIP2),CONFIG_INITRAMFS_COMPRESSION_BZIP2=y\nCONFIG_RD_BZIP2=y,# CONFIG_INITRAMFS_COMPRESSION_BZIP2 is not set\n# CONFIG_RD_BZIP2 is not set)" >> $(LINUX_DIR)/.config
		echo -e "$(if $(CONFIG_TARGET_INITRAMFS_COMPRESSION_LZMA),CONFIG_INITRAMFS_COMPRESSION_LZMA=y\nCONFIG_RD_LZMA=y,# CONFIG_INITRAMFS_COMPRESSION_LZMA is not set\n# CONFIG_RD_LZMA is not set)" >> $(LINUX_DIR)/.config
		echo -e "$(if $(CONFIG_TARGET_INITRAMFS_COMPRESSION_LZO),CONFIG_INITRAMFS_COMPRESSION_LZO=y\nCONFIG_RD_LZO=y,# CONFIG_INITRAMFS_COMPRESSION_LZO is not set\n# CONFIG_RD_LZO is not set)" >> $(LINUX_DIR)/.config
		echo -e "$(if $(CONFIG_TARGET_INITRAMFS_COMPRESSION_XZ),CONFIG_INITRAMFS_COMPRESSION_XZ=y\nCONFIG_RD_XZ=y,# CONFIG_INITRAMFS_COMPRESSION_XZ is not set\n# CONFIG_RD_XZ is not set)" >> $(LINUX_DIR)/.config
    endef
  else
    define Kernel/SetInitramfs
		rm -f $(LINUX_DIR)/.config.prev
		mv $(LINUX_DIR)/.config $(LINUX_DIR)/.config.old
		grep -v INITRAMFS $(LINUX_DIR)/.config.old > $(LINUX_DIR)/.config
		echo 'CONFIG_INITRAMFS_SOURCE="$(call qstrip,$(CONFIG_EXTERNAL_CPIO))"' >> $(LINUX_DIR)/.config
		echo 'CONFIG_INITRAMFS_ROOT_UID=$(shell id -u)' >> $(LINUX_DIR)/.config
		echo 'CONFIG_INITRAMFS_ROOT_GID=$(shell id -g)' >> $(LINUX_DIR)/.config
		echo "$(if $(CONFIG_TARGET_INITRAMFS_COMPRESSION_NONE),CONFIG_INITRAMFS_COMPRESSION_NONE=y,# CONFIG_INITRAMFS_COMPRESSION_NONE is not set)" >> $(LINUX_DIR)/.config
		echo -e "$(if $(CONFIG_TARGET_INITRAMFS_COMPRESSION_GZIP),CONFIG_INITRAMFS_COMPRESSION_GZIP=y\nCONFIG_RD_GZIP=y,# CONFIG_INITRAMFS_COMPRESSION_GZIP is not set\n# CONFIG_RD_GZIP is not set)" >> $(LINUX_DIR)/.config
		echo -e "$(if $(CONFIG_TARGET_INITRAMFS_COMPRESSION_BZIP2),CONFIG_INITRAMFS_COMPRESSION_BZIP2=y\nCONFIG_RD_BZIP2=y,# CONFIG_INITRAMFS_COMPRESSION_BZIP2 is not set\n# CONFIG_RD_BZIP2 is not set)" >> $(LINUX_DIR)/.config
		echo -e "$(if $(CONFIG_TARGET_INITRAMFS_COMPRESSION_LZMA),CONFIG_INITRAMFS_COMPRESSION_LZMA=y\nCONFIG_RD_LZMA=y,# CONFIG_INITRAMFS_COMPRESSION_LZMA is not set\n# CONFIG_RD_LZMA is not set)" >> $(LINUX_DIR)/.config
		echo -e "$(if $(CONFIG_TARGET_INITRAMFS_COMPRESSION_LZO),CONFIG_INITRAMFS_COMPRESSION_LZO=y\nCONFIG_RD_LZO=y,# CONFIG_INITRAMFS_COMPRESSION_LZO is not set\n# CONFIG_RD_LZO is not set)" >> $(LINUX_DIR)/.config
		echo -e "$(if $(CONFIG_TARGET_INITRAMFS_COMPRESSION_XZ),CONFIG_INITRAMFS_COMPRESSION_XZ=y\nCONFIG_RD_XZ=y,# CONFIG_INITRAMFS_COMPRESSION_XZ is not set\n# CONFIG_RD_XZ is not set)" >> $(LINUX_DIR)/.config
    endef
  endif
else
    define Kernel/SetInitramfs
		mv $(LINUX_DIR)/.config.set $(LINUX_DIR)/.config.old
		grep -v INITRAMFS $(LINUX_DIR)/.config.old > $(LINUX_DIR)/.config.set
		echo 'CONFIG_INITRAMFS_SOURCE=""' >> $(LINUX_DIR)/.config.set
    endef
endif

define Kernel/Configure/Default
	$(LINUX_CONF_CMD) > $(LINUX_DIR)/.config.target
# copy CONFIG_KERNEL_* settings over to .config.target
	awk '/^(#[[:space:]]+)?CONFIG_KERNEL/{sub("CONFIG_KERNEL_","CONFIG_");print}' $(TOPDIR)/.config >> $(LINUX_DIR)/.config.target
	echo "# CONFIG_KALLSYMS_EXTRA_PASS is not set" >> $(LINUX_DIR)/.config.target
	echo "# CONFIG_KALLSYMS_ALL is not set" >> $(LINUX_DIR)/.config.target
	echo "# CONFIG_KPROBES is not set" >> $(LINUX_DIR)/.config.target
	echo "CONFIG_KALLSYMS_UNCOMPRESSED=y" >> $(LINUX_DIR)/.config.target
	$(SCRIPT_DIR)/metadata.pl kconfig $(TMP_DIR)/.packageinfo $(TOPDIR)/.config $(KERNEL_PATCHVER) > $(LINUX_DIR)/.config.override
	$(SCRIPT_DIR)/kconfig.pl 'm+' '+' $(LINUX_DIR)/.config.target /dev/null $(LINUX_DIR)/.config.override > $(LINUX_DIR)/.config.set
	$(call Kernel/SetInitramfs)
	rm -rf $(KERNEL_BUILD_DIR)/modules
	cmp -s $(LINUX_DIR)/.config.set $(LINUX_DIR)/.config.prev || { \
		cp $(LINUX_DIR)/.config.set $(LINUX_DIR)/.config; \
		cp $(LINUX_DIR)/.config.set $(LINUX_DIR)/.config.prev; \
	}
	[ -d $(LINUX_DIR)/user_headers ] || $(KERNEL_MAKE) INSTALL_HDR_PATH=$(LINUX_DIR)/user_headers headers_install
	$(SH_FUNC) grep '=[ym]' $(LINUX_DIR)/.config.set | LC_ALL=C sort | md5s > $(LINUX_DIR)/.vermagic
endef

define Kernel/CompileModules/Default
	rm -f $(LINUX_DIR)/vmlinux $(LINUX_DIR)/System.map
	+$(KERNEL_MAKE) modules
endef

OBJCOPY_STRIP = -R .reginfo -R .notes -R .note -R .comment -R .mdebug -R .note.gnu.build-id

define Kernel/CompileImage/Default
	if [ -f $(KERNEL_IMG) ]; then rm -f $(KERNEL_IMG); fi;
	$(if $(CONFIG_TARGET_ROOTFS_INITRAMFS),,rm -f $(TARGET_DIR)/init)
	+$(KERNEL_MAKE) $(KERNEL_MAKEOPTS_EXPORTS) $(subst ",,$(KERNELNAME))
	$(KERNEL_CROSS)objcopy -O binary $(OBJCOPY_STRIP) -S $(LINUX_DIR)/vmlinux $(LINUX_KERNEL)
	$(KERNEL_CROSS)objcopy $(OBJCOPY_STRIP) -S $(LINUX_DIR)/vmlinux $(KERNEL_BUILD_DIR)/vmlinux.elf
endef

define Kernel/Clean/Default
	rm -f $(KERNEL_BUILD_DIR)/linux-$(LINUX_VERSION)/.configured
	rm -f $(LINUX_KERNEL)
	$(_SINGLE)$(MAKE) -C $(KERNEL_BUILD_DIR)/linux-$(LINUX_VERSION) clean
endef


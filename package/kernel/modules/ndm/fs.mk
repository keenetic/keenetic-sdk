define KernelPackage/fs-ext4
  SUBMENU:=$(FS_MENU)
  TITLE:=EXT4 filesystem support
  DEPENDS := \
    +kmod-lib-crc16 \
    +kmod-crypto-hash \
    +kmod-crypto-crc32c
  KCONFIG:= \
	CONFIG_EXT4_FS \
	CONFIG_EXT4_USE_FOR_EXT23=y \
	CONFIG_EXT4_FS_XATTR=y \
	CONFIG_JBD2
  FILES:= \
	$(LINUX_DIR)/fs/ext4/ext4.ko \
	$(LINUX_DIR)/fs/jbd2/jbd2.ko \
	$(LINUX_DIR)/fs/mbcache.ko
  AUTOLOAD:=$(call AutoLoad,30,mbcache jbd2 ext4,1)
endef

define KernelPackage/fs-ext4/description
 Kernel module for EXT4 filesystem support
endef

$(eval $(call KernelPackage,fs-ext4))


define KernelPackage/fs-jffs2
  SUBMENU:=$(FS_MENU)
  TITLE:=JFFS2 filesystem support
  DEPENDS:=+kmod-lib-zlib
  KCONFIG:= \
	CONFIG_JFFS2_FS \
	CONFIG_JFFS2_FS_WRITEBUFFER=y
  FILES:=$(LINUX_DIR)/fs/jffs2/jffs2.ko
endef

define KernelPackage/fs-jffs2/description
 Kernel module for JFFS2 support
endef

$(eval $(call KernelPackage,fs-jffs2))

define KernelPackage/fs-fuse
  SUBMENU:=$(FS_MENU)
  TITLE:=FUSE (Filesystem in Userspace) support
  KCONFIG:= CONFIG_FUSE_FS
  FILES:=$(LINUX_DIR)/fs/fuse/fuse.ko
  AUTOLOAD:=$(call AutoLoad,80,fuse)
endef

define KernelPackage/fuse/description
 Kernel module for userspace filesystem support
endef

$(eval $(call KernelPackage,fs-fuse))

define KernelPackage/fs-ubi
  SUBMENU:=$(FS_MENU)
  TITLE:=UBI FTL layer support
  DEPENDS:=+kmod-crypto-crc32c
  KCONFIG:= \
	CONFIG_MTD_UBI \
	CONFIG_MTD_UBI_WL_THRESHOLD=2048 \
	CONFIG_MTD_UBI_BEB_LIMIT=24 \
	CONFIG_MTD_UBI_BEB_RESERVE=2 \
	CONFIG_MTD_UBI_FASTMAP=n \
	CONFIG_MTD_UBI_BLOCK=n \
	CONFIG_MTD_UBI_GLUEBI=n \
	CONFIG_MTD_UBI_DEBUG=n
  FILES:=\
    $(LINUX_DIR)/drivers/mtd/ubi/ubi.ko
endef

define KernelPackage/fs-ubi/description
 Kernel module for UBI FTL support
endef

$(eval $(call KernelPackage,fs-ubi))

define KernelPackage/fs-ubifs
  SUBMENU:=$(FS_MENU)
  TITLE:=UBI filesystem support
  DEPENDS:=+kmod-crypto-deflate +kmod-crypto-zstd +kmod-lib-crc16 +kmod-fs-ubi
  KCONFIG:= \
	CONFIG_UBIFS_FS \
	CONFIG_UBIFS_FS_ADVANCED_COMPR=y \
	CONFIG_UBIFS_ATIME_SUPPORT=n \
	CONFIG_UBIFS_FS_LZO=n \
	CONFIG_UBIFS_FS_ZLIB=y \
	CONFIG_UBIFS_FS_ZSTD=y
  FILES:=$(LINUX_DIR)/fs/ubifs/ubifs.ko
endef

define KernelPackage/fs-ubifs/description
 Kernel module for UBI filesystem support
endef

$(eval $(call KernelPackage,fs-ubifs))

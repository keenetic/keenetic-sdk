define KernelPackage/mtdoops
  SUBMENU:=$(OTHER_MENU)
  TITLE:=MTD oops writing support
  KCONFIG:=CONFIG_MTD_OOPS
  FILES:=$(LINUX_DIR)/drivers/mtd/mtdoops.ko
endef

define KernelPackage/mtdoops/description
 Kernel module for support writing oops and panic messages to mtd
endef

$(eval $(call KernelPackage,mtdoops))


define KernelPackage/ndm-storage
  SUBMENU:=$(OTHER_MENU)
  TITLE:=MTD NDM Storage partition handler
  FILES:=$(LINUX_DIR)/drivers/mtd/ndm_storage.ko
endef

define KernelPackage/ndm-storage/description
 Kernel module for support extende MTD Storage partitions
endef

$(eval $(call KernelPackage,ndm-storage))

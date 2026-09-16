define KernelPackage/usb-net-kpdsl
  TITLE:=Support for ZyXEL Keenetic Plus DSL device
  KCONFIG:=CONFIG_USB_NET_KPDSL
  FILES:=$(LINUX_DIR)/drivers/$(USBNET_DIR)/kpdsl.ko
  AUTOLOAD:=$(call AutoLoad,61,kpdsl)
  $(call AddDepends/usb-net)
endef

define KernelPackage/usb-net-kpdsl/description
  Kernel support for ZyXEL Keenetic Plus DSL device
endef

$(eval $(call KernelPackage,usb-net-kpdsl))

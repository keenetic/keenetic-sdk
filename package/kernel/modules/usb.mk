#
# Copyright (C) 2006-2014 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
USBNET_DIR:=net/usb
USBHID_DIR?=hid/usbhid
USBINPUT_DIR?=input/misc

define KernelPackage/usb-core
  SUBMENU:=$(USB_MENU)
  TITLE:=Support for USB
  DEPENDS:=@USB_SUPPORT
  KCONFIG:=CONFIG_USB \
	CONFIG_USB_SUPPORT=y \
	CONFIG_USB_DEVICEFS=y \
	CONFIG_USB_DEVICE_CLASS=y
  FILES:= \
	$(LINUX_DIR)/drivers/usb/core/usbcore.ko \
	$(LINUX_DIR)/drivers/usb/common/usb-common.ko
  AUTOLOAD:=$(call AutoLoad,20,usb-common usbcore,1)
  $(call AddDepends/nls)
endef

define KernelPackage/usb-core/description
 Kernel support for USB
endef

$(eval $(call KernelPackage,usb-core))


define AddDepends/usb
  SUBMENU:=$(USB_MENU)
  DEPENDS+=+kmod-usb-core $(1)
endef


define KernelPackage/usb-gadget
  TITLE:=USB Gadget support
  KCONFIG:=CONFIG_USB_GADGET
  FILES:=
  AUTOLOAD:=
  DEPENDS:=@USB_GADGET_SUPPORT
  $(call AddDepends/usb)
endef

define KernelPackage/usb-gadget/description
  Kernel support for USB Gadget mode.
endef

$(eval $(call KernelPackage,usb-gadget))


define KernelPackage/usb-eth-gadget
  TITLE:=USB Ethernet Gadget support
  KCONFIG:= \
	CONFIG_USB_ETH \
	CONFIG_USB_ETH_RNDIS=y \
	CONFIG_USB_ETH_EEM=y
  DEPENDS:=+kmod-usb-gadget
  FILES:=$(LINUX_DIR)/drivers/usb/gadget/g_ether.ko
  AUTOLOAD:=$(call AutoLoad,52,g_ether)
  $(call AddDepends/usb)
endef

define KernelPackage/usb-eth-gadget/description
  Kernel support for USB Ethernet Gadget.
endef

$(eval $(call KernelPackage,usb-eth-gadget))


define KernelPackage/usb-uhci
  TITLE:=Support for UHCI controllers
  KCONFIG:= \
	CONFIG_USB_UHCI_ALT \
	CONFIG_USB_UHCI_HCD
  FILES:=$(LINUX_DIR)/drivers/usb/host/uhci-hcd.ko
  AUTOLOAD:=$(call AutoLoad,50,uhci-hcd,1)
  $(call AddDepends/usb)
endef

define KernelPackage/usb-uhci/description
 Kernel support for USB UHCI controllers
endef

$(eval $(call KernelPackage,usb-uhci,1))


define KernelPackage/usb-ohci
  TITLE:=Support for OHCI controllers
  KCONFIG:= \
	CONFIG_USB_OHCI \
	CONFIG_USB_OHCI_HCD \
	CONFIG_USB_OHCI_HCD_PLATFORM
  FILES:= \
	$(LINUX_DIR)/drivers/usb/host/ohci-hcd.ko \
	$(LINUX_DIR)/drivers/usb/host/ohci-platform.ko
  AUTOLOAD:=$(call AutoLoad,50,ohci-hcd ohci-platform,1)
  $(call AddDepends/usb)
endef

define KernelPackage/usb-ohci/description
 Kernel support for USB OHCI controllers
endef

$(eval $(call KernelPackage,usb-ohci,1))


define KernelPackage/usb2
  TITLE:=Support for USB2 controllers
  KCONFIG:= \
	CONFIG_USB_EHCI_HCD \
	CONFIG_USB_EHCI_HCD_PLATFORM
  FILES:= \
	$(LINUX_DIR)/drivers/usb/host/ehci-hcd.ko \
	$(LINUX_DIR)/drivers/usb/host/ehci-platform.ko
  AUTOLOAD:=$(call AutoLoad,40,ehci-hcd ehci-platform,1)
  $(call AddDepends/usb,+kmod-usb-ohci)
endef

define KernelPackage/usb2/description
 Kernel support for USB2 (EHCI) controllers
endef

$(eval $(call KernelPackage,usb2))


XHCI_MODULES := xhci-hcd
ifeq ($(strip \
	$(CONFIG_TARGET_mt7621) \
	$(CONFIG_TARGET_mt7622) \
	$(CONFIG_TARGET_mt7981) \
	$(CONFIG_TARGET_mt7986) \
	$(CONFIG_TARGET_en7512) \
	$(CONFIG_TARGET_en7516) \
	$(CONFIG_TARGET_en7528)),y)
    XHCI_MODULES += xhci-mtk
endif

XHCI_FILES := $(wildcard $(patsubst %,$(LINUX_DIR)/drivers/usb/host/%.ko,$(XHCI_MODULES)))
XHCI_AUTOLOAD := $(patsubst $(LINUX_DIR)/drivers/usb/host/%.ko,%,$(XHCI_FILES))

define KernelPackage/usb3
  TITLE:=Support for USB3 controllers
  KCONFIG:= \
	CONFIG_USB_XHCI_HCD \
	CONFIG_USB_XHCI_MTK \
	CONFIG_USB_XHCI_HCD_DEBUGGING=n \
	CONFIG_MTK_XHCI=y
  FILES:= \
	$(XHCI_FILES)
  AUTOLOAD:=$(call AutoLoad,54,$(XHCI_AUTOLOAD),1)
  $(call AddDepends/usb)
endef

define KernelPackage/usb3/config
  if PACKAGE_kmod-usb3
	config KERNEL_USB_XHCI_NO_USB3
		bool
		default y if TARGET_en7512_KN_2010
		default y if TARGET_en7512_KN_2011
		default y if TARGET_en7512_KN_2012
		default y if TARGET_en7512_KN_2110
		default y if TARGET_en7512_KN_2111
		default y if TARGET_en7516_KN_2112
		default y if TARGET_mt7621_KN_1910
		default y if TARGET_mt7621_KN_2310
		default y if TARGET_mt7621_KN_2910
		default n
  endif
endef

define KernelPackage/usb3/description
 Kernel support for USB3 (XHCI) controllers
endef

$(eval $(call KernelPackage,usb3))


define KernelPackage/usb-acm
  TITLE:=Support for modems/isdn controllers
  KCONFIG:=CONFIG_USB_ACM
  FILES:=$(LINUX_DIR)/drivers/usb/class/cdc-acm.ko
  AUTOLOAD:=$(call AutoLoad,60,cdc-acm)
$(call AddDepends/usb)
endef

define KernelPackage/usb-acm/description
 Kernel support for USB ACM devices (modems/isdn controllers)
endef

$(eval $(call KernelPackage,usb-acm))


define KernelPackage/usb-wdm
  TITLE:=USB Wireless Device Management
  KCONFIG:=CONFIG_USB_WDM
  FILES:=$(LINUX_DIR)/drivers/usb/class/cdc-wdm.ko
  AUTOLOAD:=$(call AutoProbe,cdc-wdm)
$(call AddDepends/usb)
$(call AddDepends/usb-net)
endef

define KernelPackage/usb-wdm/description
 USB Wireless Device Management support
endef

$(eval $(call KernelPackage,usb-wdm))


define KernelPackage/usb-audio
  TITLE:=Support for USB audio devices
  KCONFIG:= \
	CONFIG_USB_AUDIO \
	CONFIG_SND_USB=y \
	CONFIG_SND_USB_AUDIO
  $(call AddDepends/usb)
  $(call AddDepends/sound)
  FILES:= \
	$(LINUX_DIR)/sound/usb/snd-usbmidi-lib.ko \
	$(LINUX_DIR)/sound/usb/snd-usb-audio.ko
  AUTOLOAD:=$(call AutoLoad,60,snd-usbmidi-lib snd-usb-audio)
endef

define KernelPackage/usb-audio/description
 Kernel support for USB audio devices
endef

$(eval $(call KernelPackage,usb-audio))


define KernelPackage/usb-printer
  TITLE:=Support for printers
  KCONFIG:=CONFIG_USB_PRINTER
  FILES:=$(LINUX_DIR)/drivers/usb/class/usblp.ko
  AUTOLOAD:=$(call AutoLoad,60,usblp)
  $(call AddDepends/usb)
endef

define KernelPackage/usb-printer/description
 Kernel support for USB printers
endef

$(eval $(call KernelPackage,usb-printer))


define KernelPackage/usb-serial
  TITLE:=Support for USB-to-Serial converters
  KCONFIG:=CONFIG_USB_SERIAL
  FILES:=$(LINUX_DIR)/drivers/usb/serial/usbserial.ko
  AUTOLOAD:=$(call AutoLoad,60,usbserial)
  $(call AddDepends/usb)
endef

define KernelPackage/usb-serial/description
 Kernel support for USB-to-Serial converters
endef

$(eval $(call KernelPackage,usb-serial))


define AddDepends/usb-serial
  SUBMENU:=$(USB_MENU)
  DEPENDS+=+kmod-usb-serial $(1)
endef


define KernelPackage/usb-serial-belkin
  TITLE:=Support for Belkin devices
  KCONFIG:=CONFIG_USB_SERIAL_BELKIN
  FILES:=$(LINUX_DIR)/drivers/usb/serial/belkin_sa.ko
  AUTOLOAD:=$(call AutoLoad,65,belkin_sa)
  $(call AddDepends/usb-serial)
endef

define KernelPackage/usb-serial-belkin/description
 Kernel support for Belkin USB-to-Serial converters
endef

$(eval $(call KernelPackage,usb-serial-belkin))


define KernelPackage/usb-serial-ch341
  TITLE:=Support for CH341 devices
  KCONFIG:=CONFIG_USB_SERIAL_CH341
  FILES:=$(LINUX_DIR)/drivers/usb/serial/ch341.ko
  AUTOLOAD:=$(call AutoLoad,65,ch341)
  $(call AddDepends/usb-serial)
endef

define KernelPackage/usb-serial-ch341/description
 Kernel support for Winchiphead CH341 USB-to-Serial converters
endef

$(eval $(call KernelPackage,usb-serial-ch341))


define KernelPackage/usb-serial-ftdi
  TITLE:=Support for FTDI devices
  KCONFIG:=CONFIG_USB_SERIAL_FTDI_SIO
  FILES:=$(LINUX_DIR)/drivers/usb/serial/ftdi_sio.ko
  AUTOLOAD:=$(call AutoLoad,65,ftdi_sio)
  $(call AddDepends/usb-serial)
endef

define KernelPackage/usb-serial-ftdi/description
 Kernel support for FTDI USB-to-Serial converters
endef

$(eval $(call KernelPackage,usb-serial-ftdi))


define KernelPackage/usb-serial-ti-usb
  TITLE:=Support for TI USB 3410/5052
  KCONFIG:=CONFIG_USB_SERIAL_TI
  FILES:=$(LINUX_DIR)/drivers/usb/serial/ti_usb_3410_5052.ko
  AUTOLOAD:=$(call AutoLoad,65,ti_usb_3410_5052)
  $(call AddDepends/usb-serial)
endef

define KernelPackage/usb-serial-ti-usb/description
 Kernel support for TI USB 3410/5052 devices
endef

$(eval $(call KernelPackage,usb-serial-ti-usb))


define KernelPackage/usb-serial-ipw
  TITLE:=Support for IPWireless 3G devices
  KCONFIG:=CONFIG_USB_SERIAL_IPW
  FILES:=$(LINUX_DIR)/drivers/usb/serial/ipw.ko
  AUTOLOAD:=$(call AutoLoad,65,ipw)
  $(call AddDepends/usb-serial)
endef

$(eval $(call KernelPackage,usb-serial-ipw))


define KernelPackage/usb-serial-mct
  TITLE:=Support for Magic Control Tech. devices
  KCONFIG:=CONFIG_USB_SERIAL_MCT_U232
  FILES:=$(LINUX_DIR)/drivers/usb/serial/mct_u232.ko
  AUTOLOAD:=$(call AutoLoad,65,mct_u232)
  $(call AddDepends/usb-serial)
endef

define KernelPackage/usb-serial-mct/description
 Kernel support for Magic Control Technology USB-to-Serial converters
endef

$(eval $(call KernelPackage,usb-serial-mct))


define KernelPackage/usb-serial-mos7720
  TITLE:=Support for Moschip MOS7720 devices
  KCONFIG:=CONFIG_USB_SERIAL_MOS7720
  FILES:=$(LINUX_DIR)/drivers/usb/serial/mos7720.ko
  AUTOLOAD:=$(call AutoLoad,65,mos7720)
  $(call AddDepends/usb-serial)
endef

define KernelPackage/usb-serial-mos7720/description
 Kernel support for Moschip MOS7720 USB-to-Serial converters
endef

$(eval $(call KernelPackage,usb-serial-mos7720))


define KernelPackage/usb-serial-pl2303
  TITLE:=Support for Prolific PL2303 devices
  KCONFIG:=CONFIG_USB_SERIAL_PL2303
  FILES:=$(LINUX_DIR)/drivers/usb/serial/pl2303.ko
  AUTOLOAD:=$(call AutoLoad,65,pl2303)
  $(call AddDepends/usb-serial)
endef

define KernelPackage/usb-serial-pl2303/description
 Kernel support for Prolific PL2303 USB-to-Serial converters
endef

$(eval $(call KernelPackage,usb-serial-pl2303))


define KernelPackage/usb-serial-cp210x
  TITLE:=Support for Silicon Labs cp210x devices
  KCONFIG:=CONFIG_USB_SERIAL_CP210X
  FILES:=$(LINUX_DIR)/drivers/usb/serial/cp210x.ko
  AUTOLOAD:=$(call AutoLoad,65,cp210x)
  $(call AddDepends/usb-serial)
endef

define KernelPackage/usb-serial-cp210x/description
 Kernel support for Silicon Labs cp210x USB-to-Serial converters
endef

$(eval $(call KernelPackage,usb-serial-cp210x))


define KernelPackage/usb-serial-ark3116
  TITLE:=Support for ArkMicroChips ARK3116 devices
  KCONFIG:=CONFIG_USB_SERIAL_ARK3116
  FILES:=$(LINUX_DIR)/drivers/usb/serial/ark3116.ko
  AUTOLOAD:=$(call AutoLoad,65,ark3116)
  $(call AddDepends/usb-serial)
endef

define KernelPackage/usb-serial-ark3116/description
 Kernel support for ArkMicroChips ARK3116 USB-to-Serial converters
endef

$(eval $(call KernelPackage,usb-serial-ark3116))


define KernelPackage/usb-serial-oti6858
  TITLE:=Support for Ours Technology OTI6858 devices
  KCONFIG:=CONFIG_USB_SERIAL_OTI6858
  FILES:=$(LINUX_DIR)/drivers/usb/serial/oti6858.ko
  AUTOLOAD:=$(call AutoLoad,65,oti6858)
  $(call AddDepends/usb-serial)
endef

define KernelPackage/usb-serial-oti6858/description
 Kernel support for Ours Technology OTI6858 USB-to-Serial converters
endef

$(eval $(call KernelPackage,usb-serial-oti6858))


define KernelPackage/usb-serial-sierrawireless
  TITLE:=Support for Sierra Wireless devices
  KCONFIG:=CONFIG_USB_SERIAL_SIERRAWIRELESS
  FILES:=$(LINUX_DIR)/drivers/usb/serial/sierra.ko
  AUTOLOAD:=$(call AutoLoad,65,sierra)
  $(call AddDepends/usb-serial)
endef

define KernelPackage/usb-serial-sierrawireless/description
 Kernel support for Sierra Wireless devices
endef

$(eval $(call KernelPackage,usb-serial-sierrawireless))


define KernelPackage/usb-serial-visor
  TITLE:=Support for Handspring Visor devices
  KCONFIG:=CONFIG_USB_SERIAL_VISOR
  FILES:=$(LINUX_DIR)/drivers/usb/serial/visor.ko
  AUTOLOAD:=$(call AutoLoad,65,visor)
  $(call AddDepends/usb-serial)
endef

define KernelPackage/usb-serial-visor/description
 Kernel support for Handspring Visor PDAs
endef

$(eval $(call KernelPackage,usb-serial-visor))


define KernelPackage/usb-serial-cypress-m8
  TITLE:=Support for CypressM8 USB-Serial
  KCONFIG:=CONFIG_USB_SERIAL_CYPRESS_M8
  FILES:=$(LINUX_DIR)/drivers/usb/serial/cypress_m8.ko
  AUTOLOAD:=$(call AutoLoad,65,cypress_m8)
  $(call AddDepends/usb-serial)
endef

define KernelPackage/usb-serial-cypress-m8/description
 Kernel support for devices with Cypress M8 USB to Serial chip
 (for example, the Delorme Earthmate LT-20 GPS)
 Supported microcontrollers in the CY4601 family are:
 CY7C63741 CY7C63742 CY7C63743 CY7C64013
endef

$(eval $(call KernelPackage,usb-serial-cypress-m8))


define KernelPackage/usb-serial-keyspan
  TITLE:=Support for Keyspan USB-to-Serial devices
  KCONFIG:= \
	CONFIG_USB_SERIAL_KEYSPAN \
	CONFIG_USB_SERIAL_KEYSPAN_USA28 \
	CONFIG_USB_SERIAL_KEYSPAN_USA28X \
	CONFIG_USB_SERIAL_KEYSPAN_USA28XA \
	CONFIG_USB_SERIAL_KEYSPAN_USA28XB \
	CONFIG_USB_SERIAL_KEYSPAN_USA19 \
	CONFIG_USB_SERIAL_KEYSPAN_USA18X \
	CONFIG_USB_SERIAL_KEYSPAN_USA19W \
	CONFIG_USB_SERIAL_KEYSPAN_USA19QW \
	CONFIG_USB_SERIAL_KEYSPAN_USA19QI \
	CONFIG_USB_SERIAL_KEYSPAN_MPR \
	CONFIG_USB_SERIAL_KEYSPAN_USA49W \
	CONFIG_USB_SERIAL_KEYSPAN_USA49WLC
  FILES:=$(LINUX_DIR)/drivers/usb/serial/keyspan.ko
  AUTOLOAD:=$(call AutoLoad,65,keyspan)
  $(call AddDepends/usb-serial)
endef

define KernelPackage/usb-serial-keyspan/description
 Kernel support for Keyspan USB-to-Serial devices
endef

$(eval $(call KernelPackage,usb-serial-keyspan))


define KernelPackage/usb-serial-wwan
  TITLE:=Support for GSM and CDMA modems
  KCONFIG:=CONFIG_USB_SERIAL_WWAN
  FILES:=$(LINUX_DIR)/drivers/usb/serial/usb_wwan.ko
  AUTOLOAD:=$(call AutoLoad,61,usb_wwan)
  $(call AddDepends/usb-serial)
endef

define KernelPackage/usb-serial-wwan/description
 Kernel support for USB GSM and CDMA modems
endef

$(eval $(call KernelPackage,usb-serial-wwan))


define KernelPackage/usb-serial-option
  TITLE:=Support for Option HSDPA modems
  DEPENDS:=+kmod-usb-serial-wwan
  KCONFIG:=CONFIG_USB_SERIAL_OPTION
  FILES:=$(LINUX_DIR)/drivers/usb/serial/option.ko
  AUTOLOAD:=$(call AutoLoad,65,option)
  $(call AddDepends/usb-serial)
endef

define KernelPackage/usb-serial-option/description
 Kernel support for Option HSDPA modems
endef

$(eval $(call KernelPackage,usb-serial-option))


define KernelPackage/usb-serial-qualcomm
  TITLE:=Support for Qualcomm USB serial
  KCONFIG:=CONFIG_USB_SERIAL_QUALCOMM
  FILES:=$(LINUX_DIR)/drivers/usb/serial/qcserial.ko
  AUTOLOAD:=$(call AutoLoad,65,qcserial)
  $(call AddDepends/usb-serial,+kmod-usb-serial-wwan)
endef

define KernelPackage/usb-serial-qualcomm/description
 Kernel support for Qualcomm USB Serial devices (Gobi)
endef

$(eval $(call KernelPackage,usb-serial-qualcomm))


define KernelPackage/usb-storage
  TITLE:=USB Storage support
  DEPENDS:= +kmod-scsi-core
  KCONFIG:=CONFIG_USB_STORAGE
  FILES:=$(LINUX_DIR)/drivers/usb/storage/usb-storage.ko
  AUTOLOAD:=$(call AutoProbe,usb-storage,1)
  $(call AddDepends/usb)
endef

define KernelPackage/usb-storage/description
 Kernel support for USB Mass Storage devices
endef

$(eval $(call KernelPackage,usb-storage))


define KernelPackage/usb-storage-extras
  SUBMENU:=$(USB_MENU)
  TITLE:=Extra drivers for usb-storage
  DEPENDS:=+kmod-usb-storage
  KCONFIG:= \
	CONFIG_USB_STORAGE_ALAUDA \
	CONFIG_USB_STORAGE_CYPRESS_ATACB \
	CONFIG_USB_STORAGE_DATAFAB \
	CONFIG_USB_STORAGE_FREECOM \
	CONFIG_USB_STORAGE_ISD200 \
	CONFIG_USB_STORAGE_JUMPSHOT \
	CONFIG_USB_STORAGE_KARMA \
	CONFIG_USB_STORAGE_SDDR09 \
	CONFIG_USB_STORAGE_SDDR55 \
	CONFIG_USB_STORAGE_USBAT
  FILES:= \
	$(LINUX_DIR)/drivers/usb/storage/ums-alauda.ko \
	$(LINUX_DIR)/drivers/usb/storage/ums-cypress.ko \
	$(LINUX_DIR)/drivers/usb/storage/ums-datafab.ko \
	$(LINUX_DIR)/drivers/usb/storage/ums-freecom.ko \
	$(LINUX_DIR)/drivers/usb/storage/ums-isd200.ko \
	$(LINUX_DIR)/drivers/usb/storage/ums-jumpshot.ko \
	$(LINUX_DIR)/drivers/usb/storage/ums-karma.ko \
	$(LINUX_DIR)/drivers/usb/storage/ums-sddr09.ko \
	$(LINUX_DIR)/drivers/usb/storage/ums-sddr55.ko \
	$(LINUX_DIR)/drivers/usb/storage/ums-usbat.ko
  AUTOLOAD:=$(call AutoLoad,60,ums-alauda ums-cypress ums-datafab \
				ums-freecom ums-isd200 ums-jumpshot \
				ums-karma ums-sddr09 ums-sddr55 ums-usbat)
endef

define KernelPackage/usb-storage-extras/description
 Say Y here if you want to have some more drivers,
 such as for SmartMedia card readers
endef

$(eval $(call KernelPackage,usb-storage-extras))


define KernelPackage/usb-storage-uas
  SUBMENU:=$(USB_MENU)
  TITLE:=USB Attached SCSI (UASP) support
  DEPENDS:=+kmod-usb-storage
  KCONFIG:=CONFIG_USB_UAS
  FILES:=$(LINUX_DIR)/drivers/usb/storage/uas.ko
  AUTOLOAD:=$(call AutoProbe,uas)
endef

define KernelPackage/usb-storage-uas/description
 Say Y here if you want to include support for
 USB Attached SCSI (UAS/UASP), a higher
 performance protocol available on many
 newer USB 3.0 storage devices
endef

$(eval $(call KernelPackage,usb-storage-uas))


define KernelPackage/usb-atm
  TITLE:=Support for ATM on USB bus
  DEPENDS:=+kmod-atm
  KCONFIG:=CONFIG_USB_ATM
  FILES:=$(LINUX_DIR)/drivers/usb/atm/usbatm.ko
  AUTOLOAD:=$(call AutoLoad,60,usbatm)
  $(call AddDepends/usb)
endef

define KernelPackage/usb-atm/description
 Kernel support for USB DSL modems
endef

$(eval $(call KernelPackage,usb-atm))


define AddDepends/usb-atm
  SUBMENU:=$(USB_MENU)
  DEPENDS+=kmod-usb-atm $(1)
endef


define KernelPackage/usb-atm-speedtouch
  TITLE:=SpeedTouch USB ADSL modems support
  KCONFIG:=CONFIG_USB_SPEEDTOUCH
  FILES:=$(LINUX_DIR)/drivers/usb/atm/speedtch.ko
  AUTOLOAD:=$(call AutoLoad,70,speedtch)
  $(call AddDepends/usb-atm)
endef

define KernelPackage/usb-atm-speedtouch/description
 Kernel support for SpeedTouch USB ADSL modems
endef

$(eval $(call KernelPackage,usb-atm-speedtouch))


define KernelPackage/usb-atm-ueagle
  TITLE:=Eagle 8051 based USB ADSL modems support
  FILES:=$(LINUX_DIR)/drivers/usb/atm/ueagle-atm.ko
  KCONFIG:=CONFIG_USB_UEAGLEATM
  AUTOLOAD:=$(call AutoLoad,70,ueagle-atm)
  $(call AddDepends/usb-atm)
endef

define KernelPackage/usb-atm-ueagle/description
 Kernel support for Eagle 8051 based USB ADSL modems
endef

$(eval $(call KernelPackage,usb-atm-ueagle))


define KernelPackage/usb-atm-cxacru
  TITLE:=cxacru
  FILES:=$(LINUX_DIR)/drivers/usb/atm/cxacru.ko
  KCONFIG:=CONFIG_USB_CXACRU
  AUTOLOAD:=$(call AutoLoad,70,cxacru)
  $(call AddDepends/usb-atm)
endef

define KernelPackage/usb-atm-cxacru/description
 Kernel support for cxacru based USB ADSL modems
endef

$(eval $(call KernelPackage,usb-atm-cxacru))


define KernelPackage/usb-net
  TITLE:=Kernel modules for USB-to-Ethernet convertors
  DEPENDS:=+kmod-mii
  KCONFIG:=CONFIG_USB_USBNET \
	CONFIG_USB_NET_DRIVERS
  AUTOLOAD:=$(call AutoLoad,60,usbnet)
  FILES:=$(LINUX_DIR)/drivers/$(USBNET_DIR)/usbnet.ko
  $(call AddDepends/usb)
endef

define KernelPackage/usb-net/description
 Kernel modules for USB-to-Ethernet convertors
endef

$(eval $(call KernelPackage,usb-net))


define AddDepends/usb-net
  SUBMENU:=$(USB_MENU)
  DEPENDS+=+kmod-usb-net $(1)
endef


define KernelPackage/usb-net-asix
  TITLE:=Kernel module for USB-to-Ethernet Asix convertors
  DEPENDS:=+kmod-libphy
  KCONFIG:=CONFIG_USB_NET_AX8817X \
	CONFIG_USB_NET_AX88179_178A
  FILES:= \
	$(LINUX_DIR)/drivers/$(USBNET_DIR)/asix.ko \
	$(LINUX_DIR)/drivers/$(USBNET_DIR)/ax88179_178a.ko
  $(call AddDepends/usb-net)
endef

define KernelPackage/usb-net-asix/description
 Kernel module for USB-to-Ethernet Asix convertors
endef

$(eval $(call KernelPackage,usb-net-asix))


define KernelPackage/usb-net-hso
  TITLE:=Kernel module for Option USB High Speed Mobile Devices
  KCONFIG:=CONFIG_USB_HSO
  FILES:= \
	$(LINUX_DIR)/drivers/$(USBNET_DIR)/hso.ko
  AUTOLOAD:=$(call AutoLoad,61,hso)
  $(call AddDepends/usb-net)
  $(call AddDepends/rfkill)
endef

define KernelPackage/usb-net-hso/description
 Kernel module for Option USB High Speed Mobile Devices
endef

$(eval $(call KernelPackage,usb-net-hso))


define KernelPackage/usb-net-kaweth
  TITLE:=Kernel module for USB-to-Ethernet Kaweth convertors
  KCONFIG:=CONFIG_USB_KAWETH
  FILES:=$(LINUX_DIR)/drivers/$(USBNET_DIR)/kaweth.ko
  AUTOLOAD:=$(call AutoLoad,61,kaweth)
  $(call AddDepends/usb-net)
endef

define KernelPackage/usb-net-kaweth/description
 Kernel module for USB-to-Ethernet Kaweth convertors
endef

$(eval $(call KernelPackage,usb-net-kaweth))


define KernelPackage/usb-net-pegasus
  TITLE:=Kernel module for USB-to-Ethernet Pegasus convertors
  KCONFIG:=CONFIG_USB_PEGASUS
  FILES:=$(LINUX_DIR)/drivers/$(USBNET_DIR)/pegasus.ko
  AUTOLOAD:=$(call AutoLoad,61,pegasus)
  $(call AddDepends/usb-net)
endef

define KernelPackage/usb-net-pegasus/description
 Kernel module for USB-to-Ethernet Pegasus convertors
endef

$(eval $(call KernelPackage,usb-net-pegasus))


define KernelPackage/usb-net-mcs7830
  TITLE:=Kernel module for USB-to-Ethernet MCS7830 convertors
  KCONFIG:=CONFIG_USB_NET_MCS7830
  FILES:=$(LINUX_DIR)/drivers/$(USBNET_DIR)/mcs7830.ko
  AUTOLOAD:=$(call AutoLoad,61,mcs7830)
  $(call AddDepends/usb-net)
endef

define KernelPackage/usb-net-mcs7830/description
 Kernel module for USB-to-Ethernet MCS7830 convertors
endef

$(eval $(call KernelPackage,usb-net-mcs7830))


define KernelPackage/usb-net-dm9601-ether
  TITLE:=Support for DM9601 ethernet connections
  KCONFIG:=CONFIG_USB_NET_DM9601
  FILES:=$(LINUX_DIR)/drivers/$(USBNET_DIR)/dm9601.ko
  AUTOLOAD:=$(call AutoLoad,61,dm9601)
  $(call AddDepends/usb-net)
endef

define KernelPackage/usb-net-dm9601-ether/description
  Kernel support for USB DM9601 devices
endef

$(eval $(call KernelPackage,usb-net-dm9601-ether))

define KernelPackage/usb-net-cdc-ether
  TITLE:=Support for cdc ethernet connections
  KCONFIG:=CONFIG_USB_NET_CDCETHER
  FILES:=$(LINUX_DIR)/drivers/$(USBNET_DIR)/cdc_ether.ko
  AUTOLOAD:=$(call AutoLoad,61,cdc_ether)
  $(call AddDepends/usb-net)
endef

define KernelPackage/usb-net-cdc-ether/description
 Kernel support for USB CDC Ethernet devices
endef

$(eval $(call KernelPackage,usb-net-cdc-ether))


define KernelPackage/usb-net-qmi-wwan
  TITLE:=QMI WWAN driver
  KCONFIG:=CONFIG_USB_NET_QMI_WWAN
  FILES:= $(LINUX_DIR)/drivers/$(USBNET_DIR)/qmi_wwan.ko
  AUTOLOAD:=$(call AutoProbe,qmi_wwan)
  $(call AddDepends/usb-net,+kmod-usb-wdm)
endef

define KernelPackage/usb-net-qmi-wwan/description
 QMI WWAN driver for Qualcomm MSM based 3G and LTE modems
endef

$(eval $(call KernelPackage,usb-net-qmi-wwan))


define KernelPackage/usb-net-r815x
  TITLE:=Kernel module for USB-to-Ethernet RTL815x convertors
  DEPENDS:=+r815x-firmware
  KCONFIG:=CONFIG_USB_RTL8150 \
	CONFIG_USB_RTL8152
  FILES:= \
	$(LINUX_DIR)/drivers/$(USBNET_DIR)/rtl8150.ko \
	$(LINUX_DIR)/drivers/$(USBNET_DIR)/r8152.ko
  $(call AddDepends/usb-net)
endef

define KernelPackage/usb-net-r815x/description
 Kernel module for USB-to-Ethernet Realtek 8150/8152/3/6 convertors
endef

$(eval $(call KernelPackage,usb-net-r815x))

define KernelPackage/usb-net-rndis
  TITLE:=Support for RNDIS connections
  KCONFIG:=CONFIG_USB_NET_RNDIS_HOST
  FILES:= $(LINUX_DIR)/drivers/$(USBNET_DIR)/rndis_host.ko
  AUTOLOAD:=$(call AutoLoad,62,rndis_host)
  $(call AddDepends/usb-net,+kmod-usb-net-cdc-ether)
endef

define KernelPackage/usb-net-rndis/description
 Kernel support for RNDIS connections
endef

$(eval $(call KernelPackage,usb-net-rndis))


define KernelPackage/usb-net-cdc-mbim
  SUBMENU:=$(USB_MENU)
  TITLE:=Kernel module for MBIM Devices
  KCONFIG:=CONFIG_USB_NET_CDC_MBIM
  FILES:= \
   $(LINUX_DIR)/drivers/$(USBNET_DIR)/cdc_mbim.ko
  AUTOLOAD:=$(call AutoProbe,cdc_mbim)
  $(call AddDepends/usb-net,+kmod-usb-wdm +kmod-usb-net-cdc-ncm)
endef

define KernelPackage/usb-net-cdc-mbim/description
 Kernel module for CDC MBIM (Mobile Broadband Interface Model) devices
endef

$(eval $(call KernelPackage,usb-net-cdc-mbim))


define KernelPackage/usb-net-cdc-ncm
  TITLE:=Support for CDC NCM connections
  KCONFIG:=CONFIG_USB_NET_CDC_NCM
  FILES:= $(LINUX_DIR)/drivers/$(USBNET_DIR)/cdc_ncm.ko
  AUTOLOAD:=$(call AutoProbe,cdc_ncm)
  $(call AddDepends/usb-net)
endef

define KernelPackage/usb-net-cdc-ncm/description
 Kernel support for CDC NCM connections
endef

$(eval $(call KernelPackage,usb-net-cdc-ncm))


define KernelPackage/usb-net-huawei-cdc-ncm
  TITLE:=Support for Huawei CDC NCM connections
  KCONFIG:=CONFIG_USB_NET_HUAWEI_CDC_NCM
  FILES:= $(LINUX_DIR)/drivers/$(USBNET_DIR)/huawei_cdc_ncm.ko
  AUTOLOAD:=$(call AutoProbe,huawei_cdc_ncm)
  $(call AddDepends/usb-net,+kmod-usb-net-cdc-ncm +kmod-usb-wdm)
endef

define KernelPackage/usb-net-huawei-cdc-ncm/description
 Kernel support for Huawei CDC NCM connections
endef

$(eval $(call KernelPackage,usb-net-huawei-cdc-ncm))


define KernelPackage/usb-net-sierrawireless
  TITLE:=Support for Sierra Wireless devices
  KCONFIG:=CONFIG_USB_SIERRA_NET
  FILES:=$(LINUX_DIR)/drivers/net/usb/sierra_net.ko
  AUTOLOAD:=$(call AutoLoad,65,sierra_net)
  $(call AddDepends/usb-net)
endef

define KernelPackage/usb-net-sierrawireless/description
 Kernel support for Sierra Wireless devices
endef

$(eval $(call KernelPackage,usb-net-sierrawireless))


define KernelPackage/usb-net-ipheth
  TITLE:=Apple iPhone USB Ethernet driver
  KCONFIG:=CONFIG_USB_IPHETH
  FILES:=$(LINUX_DIR)/drivers/net/usb/ipheth.ko
  AUTOLOAD:=$(call AutoLoad,64,ipheth)
  $(call AddDepends/usb-net)
endef

define KernelPackage/usb-net-ipheth/description
 Kernel support for Apple iPhone USB Ethernet driver
endef

$(eval $(call KernelPackage,usb-net-ipheth))


define KernelPackage/usb-net-kalmia
  TITLE:=Samsung Kalmia based LTE USB modem
  KCONFIG:=CONFIG_USB_NET_KALMIA
  FILES:=$(LINUX_DIR)/drivers/net/usb/kalmia.ko
  AUTOLOAD:=$(call AutoProbe,kalmia)
  $(call AddDepends/usb-net)
endef

define KernelPackage/usb-net-kalmia/description
 Kernel support for Samsung Kalmia based LTE USB modem
endef

$(eval $(call KernelPackage,usb-net-kalmia))

define KernelPackage/usb-hid
  TITLE:=Support for USB Human Input Devices
  KCONFIG:=CONFIG_HID_SUPPORT=y CONFIG_USB_HID CONFIG_USB_HIDDEV=y
  FILES:=$(LINUX_DIR)/drivers/$(USBHID_DIR)/usbhid.ko
  AUTOLOAD:=$(call AutoLoad,70,usbhid)
  $(call AddDepends/usb)
  $(call AddDepends/hid,+kmod-hid-generic)
  $(call AddDepends/input,+kmod-input-evdev)
endef

define KernelPackage/usb-hid/description
 Kernel support for USB HID devices such as keyboards and mice
endef

$(eval $(call KernelPackage,usb-hid))


define KernelPackage/usb-yealink
  TITLE:=USB Yealink VOIP phone
  KCONFIG:=CONFIG_USB_YEALINK CONFIG_INPUT_YEALINK CONFIG_INPUT=m CONFIG_INPUT_MISC=y
  FILES:=$(LINUX_DIR)/drivers/$(USBINPUT_DIR)/yealink.ko
  AUTOLOAD:=$(call AutoLoad,70,yealink)
  $(call AddDepends/usb)
  $(call AddDepends/input,+kmod-input-evdev)
endef

define KernelPackage/usb-yealink/description
 Kernel support for Yealink VOIP phone
endef

$(eval $(call KernelPackage,usb-yealink))


define KernelPackage/usb-cm109
  TITLE:=Support for CM109 device
  KCONFIG:=CONFIG_USB_CM109 CONFIG_INPUT_CM109 CONFIG_INPUT=m CONFIG_INPUT_MISC=y
  FILES:=$(LINUX_DIR)/drivers/$(USBINPUT_DIR)/cm109.ko
  AUTOLOAD:=$(call AutoLoad,70,cm109)
  $(call AddDepends/usb)
  $(call AddDepends/input,+kmod-input-evdev)
endef

define KernelPackage/usb-cm109/description
 Kernel support for CM109 VOIP phone
endef

$(eval $(call KernelPackage,usb-cm109))


define KernelPackage/usb-test
  TITLE:=USB Testing Driver
  DEPENDS:=@DEVEL
  KCONFIG:=CONFIG_USB_TEST
  FILES:=$(LINUX_DIR)/drivers/usb/misc/usbtest.ko
  $(call AddDepends/usb)
endef

define KernelPackage/usb-test/description
 Kernel support for testing USB Host Controller software
endef

$(eval $(call KernelPackage,usb-test))


define KernelPackage/usbip
  TITLE:=USB-over-IP kernel support
  KCONFIG:= \
	CONFIG_USBIP_CORE=m \
	CONFIG_USBIP_DEBUG=n
  FILES:= \
	$(LINUX_DIR)/drivers/usb/usbip/usbip-core.ko
  AUTOLOAD:=$(call AutoLoad,90,usbip-core)
  $(call AddDepends/usb)
endef
$(eval $(call KernelPackage,usbip))

define KernelPackage/usbip/description
  Kernel support for USB IP
endef

define KernelPackage/usbip-client
  TITLE:=USB-over-IP client driver
  DEPENDS:=+kmod-usbip
  KCONFIG:=CONFIG_USBIP_VHCI_HCD=m
  FILES:= \
	$(LINUX_DIR)/drivers/usb/usbip/vhci-hcd.ko
  AUTOLOAD := $(call AutoLoad,95,vhci-hcd)
  $(call AddDepends/usb)
endef
$(eval $(call KernelPackage,usbip-client))

define KernelPackage/usbip-client/description
  Kernel support for USB IP client
endef

define KernelPackage/usbip-server
  TITLE:=USB-over-IP host driver
  DEPENDS:=+kmod-usbip
  KCONFIG:=CONFIG_USBIP_HOST=m
  FILES:= \
	$(LINUX_DIR)/drivers/usb/usbip/usbip-host.ko
  AUTOLOAD:=$(call AutoLoad,95,usbip-host)
  $(call AddDepends/usb)
endef
$(eval $(call KernelPackage,usbip-server))

define KernelPackage/usbip-server/description
  Kernel support for USB IP server
endef


define KernelPackage/usbmon
  TITLE:=USB traffic monitor
  KCONFIG:=CONFIG_USB_MON
  $(call AddDepends/usb)
  FILES:=$(LINUX_DIR)/drivers/usb/mon/usbmon.ko
  AUTOLOAD:=$(call AutoProbe,usbmon)
endef

define KernelPackage/usbmon/description
 Kernel support for USB traffic monitoring
endef

$(eval $(call KernelPackage,usbmon))


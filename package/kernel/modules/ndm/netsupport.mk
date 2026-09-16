define KernelPackage/ubridge
  SUBMENU:=$(NETWORK_SUPPORT_MENU)
  TITLE:=Simplified Ethernet Bridge
  KCONFIG:=CONFIG_UBRIDGE=y
  FILES:=$(LINUX_DIR)/net/bridge/ubridge.ko
endef

define KernelPackage/ubridge/description
  Kernel module for Simplified Ethernet Bridge.
endef

$(eval $(call KernelPackage,ubridge))


define KernelPackage/arouting4
  SUBMENU:=$(NETWORK_SUPPORT_MENU)
  TITLE:=IPv4 Advanced/Policy Routing Support
  KCONFIG:= \
        CONFIG_IP_ADVANCED_ROUTER=y \
        CONFIG_IP_MULTIPLE_TABLES=y \
        CONFIG_IP_ROUTE_MULTIPATH=y \
        CONFIG_IP_ROUTE_VERBOSE=n
endef


define KernelPackage/arouting4/description
  Kernel support for IPv4 advanced/policy routing
  Includes no modules
endef

$(eval $(call KernelPackage,arouting4))


define KernelPackage/mrouting4
  SUBMENU:=$(NETWORK_SUPPORT_MENU)
  TITLE:=IPv4 Multicast Routing Support
  DEPENDS:=+kmod-arouting4
  KCONFIG:= \
	CONFIG_IP_MROUTE=y \
	CONFIG_IP_MROUTE_MULTIPLE_TABLES=y \
	CONFIG_IP_PIMSM_V1=n \
	CONFIG_IP_PIMSM_V2=n
endef


define KernelPackage/mrouting4/description
  Kernel support for IPv4 multicast routing
  Includes no modules
endef

$(eval $(call KernelPackage,mrouting4))

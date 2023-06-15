#
# Copyright (C) 2022 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=ndm
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define Package/ndm
  CATEGORY:=NDM
  TITLE:=Network device manager
  DEPENDS:=+libc +SSP_SUPPORT:libssp +libsupcxx +tzdata +libopenssl +ping +arping +traceroute +reboot +nlldp +nginx +telnetd +init +ndnproxy +libndmacl_stub +libndm +libndmfw +zlib +kmod-ipt-core +kmod-ipt-filter +kmod-ipt-conntrack +kmod-ip6tables +kmod-ipt-ipopt +kmod-ipt-nat +kmod-ipt-nat6 +kmod-phr +kmod-tun +kmod-nacct +kmod-zram +kmod-ipt-ndm-extra +kmod-nf-nat-cone +!IS_EXTENDER:kmod-fast-nat +nsh +kmod-mtdoops_proc +kmod-nf-conntrack-netlink +kmod-sched-base +kmod-sch_cake +kmod-ipt-ipset-base +NDM_BACKTRACE:libunwind +NDM_ASAN_DEBUG:busybox +NDM_ASAN_DEBUG:libasan +NDM_ASAN_DEBUG:libssp +NDM_TSAN_DEBUG:busybox +NDM_TSAN_DEBUG:libtsan +NDM_UBSAN_DEBUG:busybox +NDM_UBSAN_DEBUG:libubsan +angular-ndw +HAS_BTMTK:uart_launcher
  DISABLE_RSTRIP:=y
endef

define Package/ndm/config
	source "package/private/ndm/Config.in"
endef

define Package/ndm/install
	if [ -d ./files-ndm ]; then \
		$(CP) ./files-ndm/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm))

define Package/ndm-mod-acl
  SUBMENU:=USB storage
  CATEGORY:=NDM
  TITLE:=NDM access module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind +libndmacl +ndm-mod-storage
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-acl/install
	if [ -d ./files-ndm-mod-acl ]; then \
		$(CP) ./files-ndm-mod-acl/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-acl))

define Package/ndm-mod-afp
  SUBMENU:=USB storage
  CATEGORY:=NDM
  TITLE:=NDM AFP Server module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind +netatalk +ndm-mod-mdns +ndm-mod-storage
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-afp/install
	if [ -d ./files-ndm-mod-afp ]; then \
		$(CP) ./files-ndm-mod-afp/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-afp))

define Package/ndm-mod-amend-ndms-316
  SUBMENU:=Amends
  CATEGORY:=NDM
  TITLE:=NDMS-316
  DEPENDS:=+libc +SSP_SUPPORT:libssp @TARGET_mt7621_KN_1010||TARGET_mt7628_KN_1110||TARGET_mt7628_KN_1310||TARGET_mt7628_KN_1410||TARGET_mt7628_KN_1510||TARGET_mt7628_KN_1610||TARGET_mt7628_KN_1710||TARGET_mt7621_KN_1810||TARGET_mt7621_KN_1910||TARGET_en7512_KN_2011||TARGET_en7512_KN_2111
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-amend-ndms-316/install
	if [ -d ./files-ndm-mod-amend-ndms-316 ]; then \
		$(CP) ./files-ndm-mod-amend-ndms-316/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-amend-ndms-316))

define Package/ndm-mod-base
  SUBMENU:=Base system
  CATEGORY:=NDM
  TITLE:=NDM Base module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +ndmc
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-base/install
	if [ -d ./files-ndm-mod-base ]; then \
		$(CP) ./files-ndm-mod-base/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-base))

define Package/ndm-mod-chilli
  SUBMENU:=Applications
  CATEGORY:=NDM
  TITLE:=Chilli captive portal module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind @!IS_EXTENDER +coova-chilli +ndm-mod-trafficcontrol
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-chilli/install
	if [ -d ./files-ndm-mod-chilli ]; then \
		$(CP) ./files-ndm-mod-chilli/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-chilli))

define Package/ndm-mod-cloud
  SUBMENU:=Applications
  CATEGORY:=NDM
  TITLE:=Base cloud service support
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-cloud/install
	if [ -d ./files-ndm-mod-cloud ]; then \
		$(CP) ./files-ndm-mod-cloud/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-cloud))

define Package/ndm-mod-cloudcontrol
  SUBMENU:=Applications
  CATEGORY:=NDM
  TITLE:=Cloud control application module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind +coalagent +ndm-mod-cloud
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-cloudcontrol/install
	if [ -d ./files-ndm-mod-cloudcontrol ]; then \
		$(CP) ./files-ndm-mod-cloudcontrol/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-cloudcontrol))

define Package/ndm-mod-components
  SUBMENU:=Base system
  CATEGORY:=NDM
  TITLE:=NDM components module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-components/install
	if [ -d ./files-ndm-mod-components ]; then \
		$(CP) ./files-ndm-mod-components/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-components))

define Package/ndm-mod-config-ap
  SUBMENU:=Modes
  CATEGORY:=NDM
  TITLE:=NDM AP config
  DEPENDS:=+libc +SSP_SUPPORT:libssp @USES_OLD_MODES @!IS_EXTENDER +ndm-mod-corewireless
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-config-ap/install
	if [ -d ./files-ndm-mod-config-ap ]; then \
		$(CP) ./files-ndm-mod-config-ap/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-config-ap))

define Package/ndm-mod-config-client
  SUBMENU:=Modes
  CATEGORY:=NDM
  TITLE:=NDM client mode
  DEPENDS:=+libc +SSP_SUPPORT:libssp @USES_OLD_MODES @!IS_EXTENDER +ndm-mod-corewireless
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-config-client/install
	if [ -d ./files-ndm-mod-config-client ]; then \
		$(CP) ./files-ndm-mod-config-client/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-config-client))

define Package/ndm-mod-config-extender
  SUBMENU:=Modes
  CATEGORY:=NDM
  TITLE:=NDM extender mode
  DEPENDS:=+libc +SSP_SUPPORT:libssp @!USES_OLD_MODES
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-config-extender/install
	if [ -d ./files-ndm-mod-config-extender ]; then \
		$(CP) ./files-ndm-mod-config-extender/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-config-extender))

define Package/ndm-mod-config-repeater
  SUBMENU:=Modes
  CATEGORY:=NDM
  TITLE:=NDM repeater mode
  DEPENDS:=+libc +SSP_SUPPORT:libssp @USES_OLD_MODES @!IS_EXTENDER +ndm-mod-corewireless
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-config-repeater/install
	if [ -d ./files-ndm-mod-config-repeater ]; then \
		$(CP) ./files-ndm-mod-config-repeater/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-config-repeater))

define Package/ndm-mod-corewireless
  SUBMENU:=Base system
  CATEGORY:=NDM
  TITLE:=NDM WiFi module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind +!USES_OLD_MODES:ndm-mod-config-extender +ndm-mod-dhcpd +HAS_BAND_STEERING:bndstrg +HAS_MT7603_RADIO:kmod-mt7603 +HAS_MT7610_RADIO:kmod-mt7610 +HAS_MT7613_RADIO:kmod-mt7613 +HAS_MT7615_RADIO:kmod-mt7615 +HAS_MT7628_RADIO:kmod-mt7628 +HAS_MT76X2_RADIO:kmod-mt76x2 +HAS_MT7915_RADIO:kmod-mt7915 +mtkiappd +wind
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-corewireless/install
	if [ -d ./files-ndm-mod-corewireless ]; then \
		$(CP) ./files-ndm-mod-corewireless/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-corewireless))

define Package/ndm-mod-crowdin-editor
  SUBMENU:=Debug
  CATEGORY:=NDM
  TITLE:=NDM crowdin editor module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind +crowdin-editor
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-crowdin-editor/install
	if [ -d ./files-ndm-mod-crowdin-editor ]; then \
		$(CP) ./files-ndm-mod-crowdin-editor/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-crowdin-editor))

define Package/ndm-mod-ddns
  SUBMENU:=Applications
  CATEGORY:=NDM
  TITLE:=NDM dynamic DNS client
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-ddns/install
	if [ -d ./files-ndm-mod-ddns ]; then \
		$(CP) ./files-ndm-mod-ddns/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-ddns))

define Package/ndm-mod-dhcpd
  SUBMENU:=Base system
  CATEGORY:=NDM
  TITLE:=NDM DHCP module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind +dhcp
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-dhcpd/install
	if [ -d ./files-ndm-mod-dhcpd ]; then \
		$(CP) ./files-ndm-mod-dhcpd/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-dhcpd))

define Package/ndm-mod-dlna
  SUBMENU:=USB storage
  CATEGORY:=NDM
  TITLE:=NDM DLNA module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind +minidlna +ndm-mod-storage
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-dlna/install
	if [ -d ./files-ndm-mod-dlna ]; then \
		$(CP) ./files-ndm-mod-dlna/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-dlna))

define Package/ndm-mod-dns-filter
  SUBMENU:=Internet filters
  CATEGORY:=NDM
  TITLE:=NDM DNS Filter module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind @!IS_EXTENDER
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-dns-filter/install
	if [ -d ./files-ndm-mod-dns-filter ]; then \
		$(CP) ./files-ndm-mod-dns-filter/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-dns-filter))

define Package/ndm-mod-dns-https
  SUBMENU:=Applications
  CATEGORY:=NDM
  TITLE:=NDM DNS over HTTPS module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind @!IS_EXTENDER +https-dns-proxy +ca-certificates
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-dns-https/install
	if [ -d ./files-ndm-mod-dns-https ]; then \
		$(CP) ./files-ndm-mod-dns-https/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-dns-https))

define Package/ndm-mod-dns-tls
  SUBMENU:=Applications
  CATEGORY:=NDM
  TITLE:=NDM DNS over TLS module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind @!IS_EXTENDER +stubby +ca-certificates
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-dns-tls/install
	if [ -d ./files-ndm-mod-dns-tls ]; then \
		$(CP) ./files-ndm-mod-dns-tls/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-dns-tls))

define Package/ndm-mod-dot1x
  SUBMENU:=Networking
  CATEGORY:=NDM
  TITLE:=NDM 802.1x module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind @!IS_EXTENDER +ndot1x
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-dot1x/install
	if [ -d ./files-ndm-mod-dot1x ]; then \
		$(CP) ./files-ndm-mod-dot1x/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-dot1x))

define Package/ndm-mod-dsl
  SUBMENU:=Base system
  CATEGORY:=NDM
  TITLE:=NDM xDSL module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind +kmod-ensoc_dsl +ndm-mod-dhcpd @!TARGET_en7512_KN_2010 @!TARGET_en7512_KN_2011 @!TARGET_en7512_KN_2110 @!TARGET_en7512_KN_2111
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-dsl/install
	if [ -d ./files-ndm-mod-dsl ]; then \
		$(CP) ./files-ndm-mod-dsl/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-dsl))

define Package/ndm-mod-easyconfig
  SUBMENU:=Base system
  CATEGORY:=NDM
  TITLE:=NDM NetFriend module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind @!IS_EXTENDER +!USES_NDW2_WIZARD:ndm-mod-ndw3 +accel-ppp-pppoe
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-easyconfig/install
	if [ -d ./files-ndm-mod-easyconfig ]; then \
		$(CP) ./files-ndm-mod-easyconfig/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-easyconfig))

define Package/ndm-mod-eoip
  SUBMENU:=Networking
  CATEGORY:=NDM
  TITLE:=NDM EoIP module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind @!IS_EXTENDER +kmod-gre +ndm-mod-tunnel
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-eoip/install
	if [ -d ./files-ndm-mod-eoip ]; then \
		$(CP) ./files-ndm-mod-eoip/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-eoip))

define Package/ndm-mod-exfat
  SUBMENU:=USB storage
  CATEGORY:=NDM
  TITLE:=NDM exFAT module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind +kmod-exfat-linux +ndm-mod-storage
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-exfat/install
	if [ -d ./files-ndm-mod-exfat ]; then \
		$(CP) ./files-ndm-mod-exfat/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-exfat))

define Package/ndm-mod-ext
  SUBMENU:=USB storage
  CATEGORY:=NDM
  TITLE:=NDM Ext module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind +kmod-fs-ext4 +ndm-mod-storage
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-ext/install
	if [ -d ./files-ndm-mod-ext ]; then \
		$(CP) ./files-ndm-mod-ext/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-ext))

define Package/ndm-mod-factory
  SUBMENU:=Factory
  CATEGORY:=NDM
  TITLE:=NDM Factory module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind +phr_ctl +ated +HAS_BTMTK:bluedroid +HAS_MT7603_RADIO:kmod-mt7603-ate +HAS_MT7610_RADIO:kmod-mt7610-ate +HAS_MT7613_RADIO:kmod-mt7613-ate +HAS_MT7615_RADIO:kmod-mt7615-ate +HAS_MT7628_RADIO:kmod-mt7628-ate +HAS_MT76X2_RADIO:kmod-mt76x2-ate +HAS_MT7915_RADIO:kmod-mt7915-ate +(TARGET_mt7621_KN_2310||TARGET_mt7628_KN_2210):ndm-mod-usbqmi +(TARGET_en7516||TARGET_en7512_KN_2012):ndm-mod-dsl
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-factory/install
	if [ -d ./files-ndm-mod-factory ]; then \
		$(CP) ./files-ndm-mod-factory/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-factory))

define Package/ndm-mod-fat
  SUBMENU:=USB storage
  CATEGORY:=NDM
  TITLE:=NDM FAT module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind +kmod-tfat +ndm-mod-storage
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-fat/install
	if [ -d ./files-ndm-mod-fat ]; then \
		$(CP) ./files-ndm-mod-fat/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-fat))

define Package/ndm-mod-fstools
  SUBMENU:=Debug
  CATEGORY:=NDM
  TITLE:=NDM filesystems tools module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind +ndm-mod-storage +tntfs-utils +exfat-mkfs +exfat-fsck +e2fsprogs +dosfstools
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-fstools/install
	if [ -d ./files-ndm-mod-fstools ]; then \
		$(CP) ./files-ndm-mod-fstools/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-fstools))

define Package/ndm-mod-ftp
  SUBMENU:=USB storage
  CATEGORY:=NDM
  TITLE:=NDM FTP Server module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind +pureftpd +ndm-mod-storage
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-ftp/install
	if [ -d ./files-ndm-mod-ftp ]; then \
		$(CP) ./files-ndm-mod-ftp/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-ftp))

define Package/ndm-mod-gre
  SUBMENU:=Networking
  CATEGORY:=NDM
  TITLE:=NDM GRE module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind @!IS_EXTENDER +kmod-gre +ndm-mod-tunnel +grecka
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-gre/install
	if [ -d ./files-ndm-mod-gre ]; then \
		$(CP) ./files-ndm-mod-gre/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-gre))

define Package/ndm-mod-hfsplus
  SUBMENU:=USB storage
  CATEGORY:=NDM
  TITLE:=NDM HFS+ module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind +ndm-mod-storage +kmod-thfsplus
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-hfsplus/install
	if [ -d ./files-ndm-mod-hfsplus ]; then \
		$(CP) ./files-ndm-mod-hfsplus/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-hfsplus))

define Package/ndm-mod-igmp
  SUBMENU:=Base system
  CATEGORY:=NDM
  TITLE:=NDM IGMP module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind @!IS_EXTENDER +nimproxy +kmod-igmpsn
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-igmp/install
	if [ -d ./files-ndm-mod-igmp ]; then \
		$(CP) ./files-ndm-mod-igmp/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-igmp))

define Package/ndm-mod-ike-client
  SUBMENU:=Networking
  CATEGORY:=NDM
  TITLE:=NDM IKE client module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind @!IS_EXTENDER +strongswan +ndm-mod-ipsec +kmod-xfrm-interface +ca-certificates +ndm-mod-tunnel
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-ike-client/install
	if [ -d ./files-ndm-mod-ike-client ]; then \
		$(CP) ./files-ndm-mod-ike-client/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-ike-client))

define Package/ndm-mod-interface-extras
  SUBMENU:=Extras
  CATEGORY:=NDM
  TITLE:=NDM network interface extras
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-interface-extras/install
	if [ -d ./files-ndm-mod-interface-extras ]; then \
		$(CP) ./files-ndm-mod-interface-extras/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-interface-extras))

define Package/ndm-mod-ip6
  SUBMENU:=Networking
  CATEGORY:=NDM
  TITLE:=NDM IPv6 support module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind +radvd +dhcpv6 +odhcp6c +kmod-ipv6 +kmod-sit +kmod-ip6-tunnel +kmod-ipv6_pt +kmod-nat46 +ndm-mod-tunnel
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-ip6/install
	if [ -d ./files-ndm-mod-ip6 ]; then \
		$(CP) ./files-ndm-mod-ip6/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-ip6))

define Package/ndm-mod-ipip
  SUBMENU:=Networking
  CATEGORY:=NDM
  TITLE:=NDM IPIP module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind @!IS_EXTENDER +kmod-ipip +ndm-mod-tunnel
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-ipip/install
	if [ -d ./files-ndm-mod-ipip ]; then \
		$(CP) ./files-ndm-mod-ipip/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-ipip))

define Package/ndm-mod-ipsec
  SUBMENU:=Networking
  CATEGORY:=NDM
  TITLE:=NDM IPSec module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind @!IS_EXTENDER +strongswan +strongswan-ndm-pem-plugin +(TARGET_en7512||TARGET_en7516||TARGET_en7528||TARGET_mt7621):kmod-eip93-cryptoapi +TARGET_mt7628:kmod-mtk-aes-engine +kmod-crypto-ctr +kmod-crypto-gcm +kmod-crypto-ccm +kmod-crypto-chacha20poly1305 +kmod-ipsec4
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-ipsec/install
	if [ -d ./files-ndm-mod-ipsec ]; then \
		$(CP) ./files-ndm-mod-ipsec/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-ipsec))

define Package/ndm-mod-isp-lock
  SUBMENU:=Extras
  CATEGORY:=NDM
  TITLE:=NDM ISP lock
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-isp-lock/install
	if [ -d ./files-ndm-mod-isp-lock ]; then \
		$(CP) ./files-ndm-mod-isp-lock/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-isp-lock))

define Package/ndm-mod-kabinet
  SUBMENU:=Networking
  CATEGORY:=NDM
  TITLE:=NDM Kabinet module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind @!IS_EXTENDER +kabinet
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-kabinet/install
	if [ -d ./files-ndm-mod-kabinet ]; then \
		$(CP) ./files-ndm-mod-kabinet/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-kabinet))

define Package/ndm-mod-l2tp
  SUBMENU:=Networking
  CATEGORY:=NDM
  TITLE:=NDM L2TP module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind @!IS_EXTENDER +ppp-mod-pppol2tp +ndm-mod-ppp
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-l2tp/install
	if [ -d ./files-ndm-mod-l2tp ]; then \
		$(CP) ./files-ndm-mod-l2tp/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-l2tp))

define Package/ndm-mod-lang-all
  SUBMENU:=Languages
  CATEGORY:=NDM
  TITLE:=All
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind +!(OLD_MODEL_1||OLD_MODEL_2):ndm-mod-lang-de +ndm-mod-lang-en +!(OLD_MODEL_1||OLD_MODEL_2):ndm-mod-lang-es +!(OLD_MODEL_1||OLD_MODEL_2):ndm-mod-lang-fr +!(OLD_MODEL_1||OLD_MODEL_2):ndm-mod-lang-it +!(OLD_MODEL_1||OLD_MODEL_2):ndm-mod-lang-pl +!(OLD_MODEL_1||OLD_MODEL_2):ndm-mod-lang-pt +ndm-mod-lang-ru +!(OLD_MODEL_1||OLD_MODEL_2):ndm-mod-lang-sv +!OLD_MODEL_1:ndm-mod-lang-tr +ndm-mod-lang-uk
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-lang-all/install
	if [ -d ./files-ndm-mod-lang-all ]; then \
		$(CP) ./files-ndm-mod-lang-all/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-lang-all))

define Package/ndm-mod-lang-de
  SUBMENU:=Languages
  CATEGORY:=NDM
  TITLE:=German
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind +angular-ndw-de-locale +keenetic-eula-de +!NO_DPN:keenetic-dpn-de @!(OLD_MODEL_1||OLD_MODEL_2)
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-lang-de/install
	if [ -d ./files-ndm-mod-lang-de ]; then \
		$(CP) ./files-ndm-mod-lang-de/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-lang-de))

define Package/ndm-mod-lang-en
  SUBMENU:=Languages
  CATEGORY:=NDM
  TITLE:=English
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind +angular-ndw-en-locale +keenetic-eula-en +!NO_DPN:keenetic-dpn-en
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-lang-en/install
	if [ -d ./files-ndm-mod-lang-en ]; then \
		$(CP) ./files-ndm-mod-lang-en/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-lang-en))

define Package/ndm-mod-lang-es
  SUBMENU:=Languages
  CATEGORY:=NDM
  TITLE:=Spanish
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind +angular-ndw-es-locale +keenetic-eula-es +!NO_DPN:keenetic-dpn-es @!(OLD_MODEL_1||OLD_MODEL_2)
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-lang-es/install
	if [ -d ./files-ndm-mod-lang-es ]; then \
		$(CP) ./files-ndm-mod-lang-es/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-lang-es))

define Package/ndm-mod-lang-fr
  SUBMENU:=Languages
  CATEGORY:=NDM
  TITLE:=French
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind +angular-ndw-fr-locale +keenetic-eula-fr +!NO_DPN:keenetic-dpn-fr @!(OLD_MODEL_1||OLD_MODEL_2)
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-lang-fr/install
	if [ -d ./files-ndm-mod-lang-fr ]; then \
		$(CP) ./files-ndm-mod-lang-fr/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-lang-fr))

define Package/ndm-mod-lang-it
  SUBMENU:=Languages
  CATEGORY:=NDM
  TITLE:=Italian
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind +angular-ndw-it-locale +keenetic-eula-it +!NO_DPN:keenetic-dpn-it @!(OLD_MODEL_1||OLD_MODEL_2)
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-lang-it/install
	if [ -d ./files-ndm-mod-lang-it ]; then \
		$(CP) ./files-ndm-mod-lang-it/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-lang-it))

define Package/ndm-mod-lang-pl
  SUBMENU:=Languages
  CATEGORY:=NDM
  TITLE:=Polish
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind +angular-ndw-pl-locale +keenetic-eula-pl +!NO_DPN:keenetic-dpn-pl @!(OLD_MODEL_1||OLD_MODEL_2)
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-lang-pl/install
	if [ -d ./files-ndm-mod-lang-pl ]; then \
		$(CP) ./files-ndm-mod-lang-pl/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-lang-pl))

define Package/ndm-mod-lang-pt
  SUBMENU:=Languages
  CATEGORY:=NDM
  TITLE:=Portuguese
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind +angular-ndw-pt-locale +keenetic-eula-pt +!NO_DPN:keenetic-dpn-pt @!(OLD_MODEL_1||OLD_MODEL_2)
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-lang-pt/install
	if [ -d ./files-ndm-mod-lang-pt ]; then \
		$(CP) ./files-ndm-mod-lang-pt/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-lang-pt))

define Package/ndm-mod-lang-ru
  SUBMENU:=Languages
  CATEGORY:=NDM
  TITLE:=Russian
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind +angular-ndw-ru-locale +keenetic-eula-ru +!NO_DPN:keenetic-dpn-ru
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-lang-ru/install
	if [ -d ./files-ndm-mod-lang-ru ]; then \
		$(CP) ./files-ndm-mod-lang-ru/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-lang-ru))

define Package/ndm-mod-lang-sv
  SUBMENU:=Languages
  CATEGORY:=NDM
  TITLE:=Swedish
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind +angular-ndw-sv-locale +keenetic-eula-sv +!NO_DPN:keenetic-dpn-sv @!(OLD_MODEL_1||OLD_MODEL_2)
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-lang-sv/install
	if [ -d ./files-ndm-mod-lang-sv ]; then \
		$(CP) ./files-ndm-mod-lang-sv/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-lang-sv))

define Package/ndm-mod-lang-tr
  SUBMENU:=Languages
  CATEGORY:=NDM
  TITLE:=Turkish
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind +angular-ndw-tr-locale +keenetic-eula-tr +!NO_DPN:keenetic-dpn-tr @!OLD_MODEL_1
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-lang-tr/install
	if [ -d ./files-ndm-mod-lang-tr ]; then \
		$(CP) ./files-ndm-mod-lang-tr/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-lang-tr))

define Package/ndm-mod-lang-uk
  SUBMENU:=Languages
  CATEGORY:=NDM
  TITLE:=Ukrainian
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind +angular-ndw-uk-locale +keenetic-eula-uk +!NO_DPN:keenetic-dpn-uk
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-lang-uk/install
	if [ -d ./files-ndm-mod-lang-uk ]; then \
		$(CP) ./files-ndm-mod-lang-uk/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-lang-uk))

define Package/ndm-mod-mdns
  SUBMENU:=Applications
  CATEGORY:=NDM
  TITLE:=NDM MDNS module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind @!IS_EXTENDER +avahi-daemon
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-mdns/install
	if [ -d ./files-ndm-mod-mdns ]; then \
		$(CP) ./files-ndm-mod-mdns/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-mdns))

define Package/ndm-mod-miniupnpd
  SUBMENU:=Base system
  CATEGORY:=NDM
  TITLE:=NDM UPnP module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind @!IS_EXTENDER +miniupnpd
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-miniupnpd/install
	if [ -d ./files-ndm-mod-miniupnpd ]; then \
		$(CP) ./files-ndm-mod-miniupnpd/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-miniupnpd))

define Package/ndm-mod-mobile
  SUBMENU:=Base system
  CATEGORY:=NDM
  TITLE:=NDM Mobile module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind +ndm-mod-usb
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-mobile/install
	if [ -d ./files-ndm-mod-mobile ]; then \
		$(CP) ./files-ndm-mod-mobile/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-mobile))

define Package/ndm-mod-monitor
  SUBMENU:=Applications
  CATEGORY:=NDM
  TITLE:=NDM monitor module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind +npdump +libpcap
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-monitor/install
	if [ -d ./files-ndm-mod-monitor ]; then \
		$(CP) ./files-ndm-mod-monitor/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-monitor))

define Package/ndm-mod-mws
  SUBMENU:=Base system
  CATEGORY:=NDM
  TITLE:=NDM Wi-Fi System module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind @!IS_EXTENDER +ndm-mod-dhcpd +ndm-mod-corewireless @TARGET_mt7628||TARGET_mt7621||TARGET_mt7622||TARGET_en7512||TARGET_en7516||TARGET_en7528
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-mws/install
	if [ -d ./files-ndm-mod-mws ]; then \
		$(CP) ./files-ndm-mod-mws/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-mws))

define Package/ndm-mod-nathelper-esp
  SUBMENU:=Networking
  CATEGORY:=NDM
  TITLE:=ESP Nat helper module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind @!IS_EXTENDER +kmod-nf-nathelper-esp
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-nathelper-esp/install
	if [ -d ./files-ndm-mod-nathelper-esp ]; then \
		$(CP) ./files-ndm-mod-nathelper-esp/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-nathelper-esp))

define Package/ndm-mod-nathelper-ftp
  SUBMENU:=Networking
  CATEGORY:=NDM
  TITLE:=NDM Nat helper module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind @!IS_EXTENDER +kmod-nf-nathelper-ftp
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-nathelper-ftp/install
	if [ -d ./files-ndm-mod-nathelper-ftp ]; then \
		$(CP) ./files-ndm-mod-nathelper-ftp/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-nathelper-ftp))

define Package/ndm-mod-nathelper-h323
  SUBMENU:=Networking
  CATEGORY:=NDM
  TITLE:=NDM Nat helper module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind @!IS_EXTENDER +kmod-nf-nathelper-h323
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-nathelper-h323/install
	if [ -d ./files-ndm-mod-nathelper-h323 ]; then \
		$(CP) ./files-ndm-mod-nathelper-h323/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-nathelper-h323))

define Package/ndm-mod-nathelper-pptp
  SUBMENU:=Networking
  CATEGORY:=NDM
  TITLE:=NDM Nat helper module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind @!IS_EXTENDER +kmod-nf-nathelper-pptp
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-nathelper-pptp/install
	if [ -d ./files-ndm-mod-nathelper-pptp ]; then \
		$(CP) ./files-ndm-mod-nathelper-pptp/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-nathelper-pptp))

define Package/ndm-mod-nathelper-rtsp
  SUBMENU:=Networking
  CATEGORY:=NDM
  TITLE:=NDM Nat helper module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind @!IS_EXTENDER +kmod-nf-nathelper-rtsp
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-nathelper-rtsp/install
	if [ -d ./files-ndm-mod-nathelper-rtsp ]; then \
		$(CP) ./files-ndm-mod-nathelper-rtsp/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-nathelper-rtsp))

define Package/ndm-mod-nathelper-sip
  SUBMENU:=Networking
  CATEGORY:=NDM
  TITLE:=NDM Nat helper module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind @!IS_EXTENDER +kmod-nf-nathelper-sip
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-nathelper-sip/install
	if [ -d ./files-ndm-mod-nathelper-sip ]; then \
		$(CP) ./files-ndm-mod-nathelper-sip/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-nathelper-sip))

define Package/ndm-mod-ndmp
  SUBMENU:=Applications
  CATEGORY:=NDM
  TITLE:=Cloud NDMP module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind +ndm-mod-ndns
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-ndmp/install
	if [ -d ./files-ndm-mod-ndmp ]; then \
		$(CP) ./files-ndm-mod-ndmp/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-ndmp))

define Package/ndm-mod-ndns
  SUBMENU:=Applications
  CATEGORY:=NDM
  TITLE:=KeenDNS support
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind +ndm-mod-cloud
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-ndns/install
	if [ -d ./files-ndm-mod-ndns ]; then \
		$(CP) ./files-ndm-mod-ndns/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-ndns))

define Package/ndm-mod-ndss-override
  SUBMENU:=Extras
  CATEGORY:=NDM
  TITLE:=NDM NDSS override
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-ndss-override/install
	if [ -d ./files-ndm-mod-ndss-override ]; then \
		$(CP) ./files-ndm-mod-ndss-override/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-ndss-override))

define Package/ndm-mod-ndw3
  SUBMENU:=Base system
  CATEGORY:=NDM
  TITLE:=Next-generation web interface (beta)
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind +ndw3
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-ndw3/install
	if [ -d ./files-ndm-mod-ndw3 ]; then \
		$(CP) ./files-ndm-mod-ndw3/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-ndw3))

define Package/ndm-mod-netflow
  SUBMENU:=Networking
  CATEGORY:=NDM
  TITLE:=NDM NetFlow module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind @!IS_EXTENDER +kmod-ipt-netflow +kmod-ipt-raw
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-netflow/install
	if [ -d ./files-ndm-mod-netflow ]; then \
		$(CP) ./files-ndm-mod-netflow/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-netflow))

define Package/ndm-mod-nextdns
  SUBMENU:=Internet filters
  CATEGORY:=NDM
  TITLE:=NDM NextDNS module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind @!IS_EXTENDER +ndm-mod-dns-filter +ndm-mod-dns-https +ndm-mod-dns-tls
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-nextdns/install
	if [ -d ./files-ndm-mod-nextdns ]; then \
		$(CP) ./files-ndm-mod-nextdns/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-nextdns))

define Package/ndm-mod-ntce
  SUBMENU:=Applications
  CATEGORY:=NDM
  TITLE:=NDM NTCE module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind @!IS_EXTENDER +ntce-pace2 +kmod-nnfm +kmod-dummy
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-ntce/install
	if [ -d ./files-ndm-mod-ntce ]; then \
		$(CP) ./files-ndm-mod-ntce/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-ntce))

define Package/ndm-mod-ntfs
  SUBMENU:=USB storage
  CATEGORY:=NDM
  TITLE:=NDM NTFS module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind +kmod-tntfs +ndm-mod-storage
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-ntfs/install
	if [ -d ./files-ndm-mod-ntfs ]; then \
		$(CP) ./files-ndm-mod-ntfs/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-ntfs))

define Package/ndm-mod-nvox
  SUBMENU:=USB modems
  CATEGORY:=NDM
  TITLE:=NDM NVOX module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind +nvox +ndm-mod-usb
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-nvox/install
	if [ -d ./files-ndm-mod-nvox ]; then \
		$(CP) ./files-ndm-mod-nvox/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-nvox))

define Package/ndm-mod-openvpn
  SUBMENU:=Networking
  CATEGORY:=NDM
  TITLE:=NDM OpenVPN module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind @!IS_EXTENDER +openvpn
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-openvpn/install
	if [ -d ./files-ndm-mod-openvpn ]; then \
		$(CP) ./files-ndm-mod-openvpn/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-openvpn))

define Package/ndm-mod-opkg
  SUBMENU:=Opkg
  CATEGORY:=NDM
  TITLE:=NDM Opkg module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind @!IS_EXTENDER +kmod-loop +npkg +nsh-static +opkg_led_ctl +iperf3
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-opkg/install
	if [ -d ./files-ndm-mod-opkg ]; then \
		$(CP) ./files-ndm-mod-opkg/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-opkg))

define Package/ndm-mod-opkg-kmod-audio
  SUBMENU:=Opkg
  CATEGORY:=NDM
  TITLE:=NDM Opkg kernel USB audio modules
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind +ndm-mod-opkg +kmod-sound-core +kmod-sound-seq +kmod-usb-audio +kmod-usb-hid
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-opkg-kmod-audio/install
	if [ -d ./files-ndm-mod-opkg-kmod-audio ]; then \
		$(CP) ./files-ndm-mod-opkg-kmod-audio/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-opkg-kmod-audio))

define Package/ndm-mod-opkg-kmod-dvb-tuner
  SUBMENU:=Opkg
  CATEGORY:=NDM
  TITLE:=NDM Opkg DVB tuner module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind +ndm-mod-opkg +kmod-dvb-usb +kmod-dvb-usb-v2 +kmod-media-tuner
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-opkg-kmod-dvb-tuner/install
	if [ -d ./files-ndm-mod-opkg-kmod-dvb-tuner ]; then \
		$(CP) ./files-ndm-mod-opkg-kmod-dvb-tuner/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-opkg-kmod-dvb-tuner))

define Package/ndm-mod-opkg-kmod-fs
  SUBMENU:=Opkg
  CATEGORY:=NDM
  TITLE:=NDM Opkg kernel filesystems modules
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind +ndm-mod-opkg +ndm-mod-storage +kmod-fs-fuse +kmod-fs-cifs +kmod-fs-nfs +kmod-fs-nfsd +kmod-fs-udf +kmod-fs-isofs
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-opkg-kmod-fs/install
	if [ -d ./files-ndm-mod-opkg-kmod-fs ]; then \
		$(CP) ./files-ndm-mod-opkg-kmod-fs/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-opkg-kmod-fs))

define Package/ndm-mod-opkg-kmod-netfilter
  SUBMENU:=Opkg
  CATEGORY:=NDM
  TITLE:=NDM Opkg kernel netfilter modules
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind +ndm-mod-opkg +ndm-mod-ip6 +kmod-arptables +kmod-ebtables +kmod-ebtables-ipv4 +kmod-ebtables-ipv6 +kmod-ip6tables-extra +kmod-ipt-nat6 +kmod-nf-nat6 +kmod-nf-nat6-extra +kmod-ipt-conntrack +kmod-ipt-conntrack-extra +kmod-ipt-extra +kmod-ipt-filter +kmod-ipt-hashlimit +kmod-ipt-ipopt-extended +kmod-ipt-iprange +kmod-ipt-ipsec +kmod-ipt-nat +kmod-ipt-nat-extra +kmod-ipt-tee +kmod-ipt-tproxy +kmod-ipt-u32 +kmod-ipt-nflog +kmod-nf-conntrack-netlink +kmod-nfnetlink-queue +kmod-nfnetlink-log +kmod-ipt-ipset +kmod-lib-textsearch +kmod-xfrm-interface +kmod-ip-vti +kmod-ip6-vti
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-opkg-kmod-netfilter/install
	if [ -d ./files-ndm-mod-opkg-kmod-netfilter ]; then \
		$(CP) ./files-ndm-mod-opkg-kmod-netfilter/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-opkg-kmod-netfilter))

define Package/ndm-mod-opkg-kmod-netfilter-addons
  SUBMENU:=Opkg
  CATEGORY:=NDM
  TITLE:=NDM Opkg kernel Xtables addons modules
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind +ndm-mod-opkg +ndm-mod-opkg-kmod-netfilter +kmod-ipt-raw +kmod-ipt-raw6 +kmod-ipt-conntrack-raw +kmod-ipt-account +kmod-ipt-chaos +kmod-ipt-condition +kmod-ipt-delude +kmod-ipt-dhcpmac +kmod-ipt-dnetmap +kmod-ipt-fuzzy +kmod-ipt-geoip +kmod-ipt-iface +kmod-ipt-ipmark +kmod-ipt-ipp2p +kmod-ipt-ipv4options +kmod-ipt-length2 +kmod-ipt-logmark +kmod-ipt-lscan +kmod-ipt-psd +kmod-ipt-quota2 +kmod-ipt-sysrq +kmod-ipt-tarpit
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-opkg-kmod-netfilter-addons/install
	if [ -d ./files-ndm-mod-opkg-kmod-netfilter-addons ]; then \
		$(CP) ./files-ndm-mod-opkg-kmod-netfilter-addons/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-opkg-kmod-netfilter-addons))

define Package/ndm-mod-opkg-kmod-tc
  SUBMENU:=Opkg
  CATEGORY:=NDM
  TITLE:=NDM Opkg kernel trafficcontrol modules
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind +ndm-mod-opkg +kmod-sched +kmod-sched-connmark
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-opkg-kmod-tc/install
	if [ -d ./files-ndm-mod-opkg-kmod-tc ]; then \
		$(CP) ./files-ndm-mod-opkg-kmod-tc/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-opkg-kmod-tc))

define Package/ndm-mod-opkg-kmod-usbip
  SUBMENU:=Opkg
  CATEGORY:=NDM
  TITLE:=NDM Opkg kernel USB IP modules
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind +ndm-mod-opkg +kmod-usbip +kmod-usbip-client +kmod-usbip-server
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-opkg-kmod-usbip/install
	if [ -d ./files-ndm-mod-opkg-kmod-usbip ]; then \
		$(CP) ./files-ndm-mod-opkg-kmod-usbip/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-opkg-kmod-usbip))

define Package/ndm-mod-opkg-kmod-video
  SUBMENU:=Opkg
  CATEGORY:=NDM
  TITLE:=NDM Opkg kernel USB video modules
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind +ndm-mod-opkg +kmod-video-core +kmod-video-uvc +kmod-video-gspca-core +kmod-video-gspca-sonixj +kmod-video-gspca-ov519
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-opkg-kmod-video/install
	if [ -d ./files-ndm-mod-opkg-kmod-video ]; then \
		$(CP) ./files-ndm-mod-opkg-kmod-video/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-opkg-kmod-video))

define Package/ndm-mod-pingcheck
  SUBMENU:=Applications
  CATEGORY:=NDM
  TITLE:=NDM PingCheck
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind @!IS_EXTENDER
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-pingcheck/install
	if [ -d ./files-ndm-mod-pingcheck ]; then \
		$(CP) ./files-ndm-mod-pingcheck/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-pingcheck))

define Package/ndm-mod-ppe
  SUBMENU:=Base system
  CATEGORY:=NDM
  TITLE:=NDM PPE module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind @!IS_EXTENDER +kmod-fastvpn +HAS_HWNAT:hw_nat_ctl
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-ppe/install
	if [ -d ./files-ndm-mod-ppe ]; then \
		$(CP) ./files-ndm-mod-ppe/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-ppe))

define Package/ndm-mod-ppp
  SUBMENU:=Networking
  CATEGORY:=NDM
  TITLE:=NDM PPP module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind @!IS_EXTENDER +ppp +kmod-resetnds
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-ppp/install
	if [ -d ./files-ndm-mod-ppp ]; then \
		$(CP) ./files-ndm-mod-ppp/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-ppp))

define Package/ndm-mod-pppoe
  SUBMENU:=Networking
  CATEGORY:=NDM
  TITLE:=NDM PPPoE module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind @!IS_EXTENDER +ppp-mod-pppoe +ndm-mod-ppp +kmod-pppoe_pt
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-pppoe/install
	if [ -d ./files-ndm-mod-pppoe ]; then \
		$(CP) ./files-ndm-mod-pppoe/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-pppoe))

define Package/ndm-mod-pptp
  SUBMENU:=Networking
  CATEGORY:=NDM
  TITLE:=NDM PPTP module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind @!IS_EXTENDER +ppp-mod-pptp +ndm-mod-ppp
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-pptp/install
	if [ -d ./files-ndm-mod-pptp ]; then \
		$(CP) ./files-ndm-mod-pptp/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-pptp))

define Package/ndm-mod-proxy
  SUBMENU:=Networking
  CATEGORY:=NDM
  TITLE:=NDM Proxy module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind @!IS_EXTENDER +badvpn
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-proxy/install
	if [ -d ./files-ndm-mod-proxy ]; then \
		$(CP) ./files-ndm-mod-proxy/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-proxy))

define Package/ndm-mod-safedns
  SUBMENU:=Internet filters
  CATEGORY:=NDM
  TITLE:=NDM SafeDNS module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind @!IS_EXTENDER +ndm-mod-dns-filter
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-safedns/install
	if [ -d ./files-ndm-mod-safedns ]; then \
		$(CP) ./files-ndm-mod-safedns/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-safedns))

define Package/ndm-mod-sftp
  SUBMENU:=USB storage
  CATEGORY:=NDM
  TITLE:=NDM SFTP Server module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind +openssh-sftp-server +ndm-mod-ssh +ndm-mod-storage
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-sftp/install
	if [ -d ./files-ndm-mod-sftp ]; then \
		$(CP) ./files-ndm-mod-sftp/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-sftp))

define Package/ndm-mod-shell
  SUBMENU:=Debug
  CATEGORY:=NDM
  TITLE:=NDM shell module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind +busybox +iptables +iptables-mod-conntrack-extra +iptables-mod-ipopt +iptables-mod-ipsec +iptables-mod-ndm-extra +ip +ip6tables +iperf3 +ipset +rt_reg +tcpdump +wireless-tools +(TARGET_en7516||TARGET_en7512):br2684ctl +TARGET_mt7628:mt7628-switch +TARGET_en7528:mt7530-switch +TARGET_en7516:mt7530-switch +TARGET_en7512:mt7530-switch +TARGET_mt7621:mt7530-switch +TARGET_mt7622_KN_1811:mt7530-switch +TARGET_mt7621_ku_rd:rtl8370m-switch +TARGET_mt7622_ZN_1811:mt7530-switch
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-shell/install
	if [ -d ./files-ndm-mod-shell ]; then \
		$(CP) ./files-ndm-mod-shell/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-shell))

define Package/ndm-mod-skydns
  SUBMENU:=Internet filters
  CATEGORY:=NDM
  TITLE:=NDM SkyDNS module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind @!IS_EXTENDER +ndm-mod-dns-filter
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-skydns/install
	if [ -d ./files-ndm-mod-skydns ]; then \
		$(CP) ./files-ndm-mod-skydns/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-skydns))

define Package/ndm-mod-snmp
  SUBMENU:=Applications
  CATEGORY:=NDM
  TITLE:=NDM SNMP module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind +mini_snmpd
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-snmp/install
	if [ -d ./files-ndm-mod-snmp ]; then \
		$(CP) ./files-ndm-mod-snmp/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-snmp))

define Package/ndm-mod-ssh
  SUBMENU:=Base system
  CATEGORY:=NDM
  TITLE:=NDM SSH module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind +dropbear
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-ssh/install
	if [ -d ./files-ndm-mod-ssh ]; then \
		$(CP) ./files-ndm-mod-ssh/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-ssh))

define Package/ndm-mod-sstp
  SUBMENU:=Networking
  CATEGORY:=NDM
  TITLE:=NDM SSTP module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind @!IS_EXTENDER +ndm-mod-ppp +sstp-client
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-sstp/install
	if [ -d ./files-ndm-mod-sstp ]; then \
		$(CP) ./files-ndm-mod-sstp/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-sstp))

define Package/ndm-mod-sstp-server
  SUBMENU:=Networking
  CATEGORY:=NDM
  TITLE:=NDM SSTP VPN Server module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind @!IS_EXTENDER +ndm-mod-ndns +accel-ppp-sstp
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-sstp-server/install
	if [ -d ./files-ndm-mod-sstp-server ]; then \
		$(CP) ./files-ndm-mod-sstp-server/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-sstp-server))

define Package/ndm-mod-storage
  SUBMENU:=USB storage
  CATEGORY:=NDM
  TITLE:=NDM storage module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind +kmod-fs-jffs2 +kmod-lbdaf +kmod-nls-cp1251 +kmod-nls-cp437 +kmod-nls-cp866 +kmod-nls-utf8 +kmod-usb-storage +ndm-mod-usb +USES_EXTENDED_STORAGE:kmod-fs-ubifs +USES_EXTENDED_STORAGE:kmod-ndm-storage
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-storage/install
	if [ -d ./files-ndm-mod-storage ]; then \
		$(CP) ./files-ndm-mod-storage/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-storage))

define Package/ndm-mod-trafficcontrol
  SUBMENU:=Applications
  CATEGORY:=NDM
  TITLE:=NDM traffic control module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind @!IS_EXTENDER +kmod-ntc
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-trafficcontrol/install
	if [ -d ./files-ndm-mod-trafficcontrol ]; then \
		$(CP) ./files-ndm-mod-trafficcontrol/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-trafficcontrol))

define Package/ndm-mod-transmission
  SUBMENU:=USB storage
  CATEGORY:=NDM
  TITLE:=NDM torrent module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind +ndm-mod-storage +transmission-daemon +TARGET_mt7628:transmission-web-control-tiny +(TARGET_en7512||TARGET_en7516||TARGET_en7528||TARGET_mt7621||TARGET_mt7622):transmission-web-control-full
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-transmission/install
	if [ -d ./files-ndm-mod-transmission ]; then \
		$(CP) ./files-ndm-mod-transmission/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-transmission))

define Package/ndm-mod-tsmb
  SUBMENU:=USB storage
  CATEGORY:=NDM
  TITLE:=NDM CIFS TSMB module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind +tsmb +ndm-mod-mdns +ndm-mod-storage +nprint +kmod-usb-printer +kmod-nf-fastpath-smb
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-tsmb/install
	if [ -d ./files-ndm-mod-tsmb ]; then \
		$(CP) ./files-ndm-mod-tsmb/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-tsmb))

define Package/ndm-mod-tunnel
  SUBMENU:=Networking
  CATEGORY:=NDM
  TITLE:=NDM Tunnel module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-tunnel/install
	if [ -d ./files-ndm-mod-tunnel ]; then \
		$(CP) ./files-ndm-mod-tunnel/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-tunnel))

define Package/ndm-mod-udpxy
  SUBMENU:=Applications
  CATEGORY:=NDM
  TITLE:=NDM UDP Proxy module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind @!IS_EXTENDER +udpxy
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-udpxy/install
	if [ -d ./files-ndm-mod-udpxy ]; then \
		$(CP) ./files-ndm-mod-udpxy/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-udpxy))

define Package/ndm-mod-usb
  SUBMENU:=Base system
  CATEGORY:=NDM
  TITLE:=NDM USB module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind +kmod-scsi-cdrom +kmod-scsi-generic +kmod-usb_extras +TARGET_mt7628:kmod-usb2 +(TARGET_en7528||TARGET_en7516||TARGET_en7512||TARGET_mt7621||TARGET_mt7622):kmod-usb3
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-usb/install
	if [ -d ./files-ndm-mod-usb ]; then \
		$(CP) ./files-ndm-mod-usb/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-usb))

define Package/ndm-mod-usbdsl
  SUBMENU:=USB modems
  CATEGORY:=NDM
  TITLE:=NDM USB xDSL dongle support module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind @!IS_EXTENDER +ndm-mod-dhcpd +ndm-mod-usbnet +kmod-usb-net-kpdsl +kmod-mt-vdsl-driver +mt-vdsl-cli
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-usbdsl/install
	if [ -d ./files-ndm-mod-usbdsl ]; then \
		$(CP) ./files-ndm-mod-usbdsl/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-usbdsl))

define Package/ndm-mod-usblte
  SUBMENU:=USB modems
  CATEGORY:=NDM
  TITLE:=NDM UsbLte module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind @!IS_EXTENDER +ndm-mod-usb +ndm-mod-mobile +ndm-mod-dhcpd +kmod-usb-storage +kmod-usb-serial-option +kmod-usb-acm +kmod-usb-net-huawei-cdc-ncm +kmod-usb-net-kalmia +kmod-usb-net-rndis +kmod-usb-net-cdc-ether +kmod-ubridge +(TARGET_mt7621_KN_2311||TARGET_mt7621_KN_2910||TARGET_mt7628_KN_2211):ltefw +(TARGET_mt7621_KN_2311||TARGET_mt7621_KN_2910||TARGET_mt7628_KN_2211):qdloader
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-usblte/install
	if [ -d ./files-ndm-mod-usblte ]; then \
		$(CP) ./files-ndm-mod-usblte/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-usblte))

define Package/ndm-mod-usbmodem
  SUBMENU:=USB modems
  CATEGORY:=NDM
  TITLE:=NDM USB modems support module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind @!IS_EXTENDER +ndm-mod-ppp +ndm-mod-usb +ndm-mod-mobile +kmod-usb-storage +kmod-usb-serial-option +kmod-usb-acm +kmod-usb-serial-sierrawireless +kmod-ubridge +zted
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-usbmodem/install
	if [ -d ./files-ndm-mod-usbmodem ]; then \
		$(CP) ./files-ndm-mod-usbmodem/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-usbmodem))

define Package/ndm-mod-usbnet
  SUBMENU:=USB modems
  CATEGORY:=NDM
  TITLE:=NDM USB Ethernet support module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind @!IS_EXTENDER +ndm-mod-dhcpd +ndm-mod-usb +ndm-mod-mobile +kmod-usb-net-rndis +kmod-usb-net-cdc-ether +kmod-ubridge
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-usbnet/install
	if [ -d ./files-ndm-mod-usbnet ]; then \
		$(CP) ./files-ndm-mod-usbnet/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-usbnet))

define Package/ndm-mod-usbnet-extra
  SUBMENU:=USB modems
  CATEGORY:=NDM
  TITLE:=NDM USB Ethernet support (extra)
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind @!IS_EXTENDER +ndm-mod-usbnet +kmod-usb-net-asix +kmod-usb-net-r815x +kmod-usb-net-dm9601-ether
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-usbnet-extra/install
	if [ -d ./files-ndm-mod-usbnet-extra ]; then \
		$(CP) ./files-ndm-mod-usbnet-extra/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-usbnet-extra))

define Package/ndm-mod-usbqmi
  SUBMENU:=USB modems
  CATEGORY:=NDM
  TITLE:=NDM UsbQmi module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind @!IS_EXTENDER +ndm-mod-usb +ndm-mod-mobile +ndm-mod-dhcpd +kmod-usb-storage +kmod-usb-serial-option +kmod-usb-serial-qualcomm +kmod-usb-net-qmi-wwan +kmod-ubridge +(TARGET_mt7621_KN_2310||TARGET_mt7628_KN_2210):adb +(TARGET_mt7621_KN_2310||TARGET_mt7628_KN_2210):ltefw
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-usbqmi/install
	if [ -d ./files-ndm-mod-usbqmi ]; then \
		$(CP) ./files-ndm-mod-usbqmi/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-usbqmi))

define Package/ndm-mod-usbserial-extra
  SUBMENU:=USB modems
  CATEGORY:=NDM
  TITLE:=NDM USB serial adapters support (extra)
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind @!IS_EXTENDER +ndm-mod-usbmodem +kmod-usb-serial-ftdi +kmod-usb-serial-pl2303 +kmod-usb-serial-cp210x +kmod-usb-serial-ch341 +kmod-usb-serial-cypress-m8
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-usbserial-extra/install
	if [ -d ./files-ndm-mod-usbserial-extra ]; then \
		$(CP) ./files-ndm-mod-usbserial-extra/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-usbserial-extra))

define Package/ndm-mod-vpnserver
  SUBMENU:=Networking
  CATEGORY:=NDM
  TITLE:=NDM PPTP VPN Server module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind @!IS_EXTENDER +accel-ppp-pptp
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-vpnserver/install
	if [ -d ./files-ndm-mod-vpnserver ]; then \
		$(CP) ./files-ndm-mod-vpnserver/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-vpnserver))

define Package/ndm-mod-vpnserver-l2tp
  SUBMENU:=Networking
  CATEGORY:=NDM
  TITLE:=NDM L2TP/IPsec VPN Server module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind @!IS_EXTENDER +accel-ppp-l2tp +ndm-mod-ipsec +kmod-pppol2tp-kernel
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-vpnserver-l2tp/install
	if [ -d ./files-ndm-mod-vpnserver-l2tp ]; then \
		$(CP) ./files-ndm-mod-vpnserver-l2tp/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-vpnserver-l2tp))

define Package/ndm-mod-webdav
  SUBMENU:=USB storage
  CATEGORY:=NDM
  TITLE:=NDM WebDAV Server module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind +lighttpd +ndm-mod-ndns +ndm-mod-storage
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-webdav/install
	if [ -d ./files-ndm-mod-webdav ]; then \
		$(CP) ./files-ndm-mod-webdav/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-webdav))

define Package/ndm-mod-wireguard
  SUBMENU:=Networking
  CATEGORY:=NDM
  TITLE:=NDM Wireguard module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind @!IS_EXTENDER +kmod-wireguard
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-wireguard/install
	if [ -d ./files-ndm-mod-wireguard ]; then \
		$(CP) ./files-ndm-mod-wireguard/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-wireguard))

define Package/ndm-mod-wpa-eap
  SUBMENU:=Base system
  CATEGORY:=NDM
  TITLE:=NDM WPA Enterprise module
  DEPENDS:=+libc +SSP_SUPPORT:libssp +ndm +libsupcxx +NDM_BACKTRACE:libunwind +ndm-mod-corewireless +rt2860apd
  DISABLE_RSTRIP:=y
endef

define Package/ndm-mod-wpa-eap/install
	if [ -d ./files-ndm-mod-wpa-eap ]; then \
		$(CP) ./files-ndm-mod-wpa-eap/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndm-mod-wpa-eap))

define Package/ndmc
  CATEGORY:=NDM
  TITLE:=CLI (telnet) module
  DEPENDS:=+libc +SSP_SUPPORT:libssp ndm
  DISABLE_RSTRIP:=y
endef

define Package/ndmc/install
	if [ -d ./files-ndmc ]; then \
		$(CP) ./files-ndmc/* $(1); \
	fi
endef

$(eval $(call BuildPackage,ndmc))

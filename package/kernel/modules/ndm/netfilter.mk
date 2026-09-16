define KernelPackage/fast-nat
  SUBMENU:=$(NF_MENU)
  TITLE:=Fast NAT support
  KCONFIG:=CONFIG_FAST_NAT=y \
        CONFIG_FAST_NAT_V2=y \
        CONFIG_NF_CONNTRACK_PROC_COMPAT=y
  DEPENDS:=+kmod-ipt-conntrack +kmod-ipt-nat
endef

$(eval $(call KernelPackage,fast-nat))


define KernelPackage/nf-nat-cone
  SUBMENU:=$(NF_MENU)
  TITLE:=Netfilter CONE NAT support
  KCONFIG:=CONFIG_NAT_CONE=y
  $(call AddDepends/ipt,+kmod-ipt-nat)
endef

define KernelPackage/nf-nat-cone/description
 Support Cone NAT mode in addition to linux NAT.
endef

$(eval $(call KernelPackage,nf-nat-cone))


define KernelPackage/nf-fastpath-smb
  SUBMENU:=$(NF_MENU)
  TITLE:=Netfilter SMB fastpath
  KCONFIG:=CONFIG_NETFILTER_FP_SMB=y
  $(call AddDepends/ipt)
endef

define KernelPackage/nf-fastpath-smb/description
 Netfilter fastpath to speedup SMB traffic (skip NF handlers)
endef

$(eval $(call KernelPackage,nf-fastpath-smb))


define KernelPackage/nf-nathelper-h323
  SUBMENU:=$(NF_MENU)
  TITLE:=H.323 Conntrack and NAT helpers
  KCONFIG:=$(KCONFIG_NF_NATHELPER_H323)
  FILES:=$(foreach mod,$(NF_NATHELPER_H323-m),$(LINUX_DIR)/net/$(mod).ko)
  $(call AddDepends/ipt,+kmod-ipt-nat)
endef

define KernelPackage/nf-nathelper-h323/description
 Extra Netfilter (IPv4) Conntrack and NAT helpers
 Includes:
 - h323
endef

$(eval $(call KernelPackage,nf-nathelper-h323))


define KernelPackage/nf-nathelper-sip
  SUBMENU:=$(NF_MENU)
  TITLE:=SIP Conntrack and NAT helpers
  KCONFIG:=$(KCONFIG_NF_NATHELPER_SIP)
  FILES:=$(foreach mod,$(NF_NATHELPER_SIP-m),$(LINUX_DIR)/net/$(mod).ko)
  $(call AddDepends/ipt,+kmod-ipt-nat)
endef

define KernelPackage/nf-nathelper-sip/description
 Extra Netfilter (IPv4) Conntrack and NAT helpers
 Includes:
 - sip
endef

$(eval $(call KernelPackage,nf-nathelper-sip))


define KernelPackage/nf-nathelper-ftp
  SUBMENU:=$(NF_MENU)
  TITLE:=FTP Conntrack and NAT helpers
  KCONFIG:=$(KCONFIG_NF_NATHELPER_FTP)
  FILES:=$(foreach mod,$(NF_NATHELPER_FTP-m),$(LINUX_DIR)/net/$(mod).ko)
  $(call AddDepends/ipt,+kmod-ipt-nat)
endef

define KernelPackage/nf-nathelper-ftp/description
 Extra Netfilter (IPv4) Conntrack and NAT helpers
 Includes:
 - ftp
endef

$(eval $(call KernelPackage,nf-nathelper-ftp))


define KernelPackage/nf-nathelper-pptp
  SUBMENU:=$(NF_MENU)
  TITLE:=PPTP Conntrack and NAT helpers
  KCONFIG:=$(KCONFIG_NF_NATHELPER_PPTP)
  FILES:=$(foreach mod,$(NF_NATHELPER_PPTP-m),$(LINUX_DIR)/net/$(mod).ko)
  $(call AddDepends/ipt,+kmod-ipt-nat)
endef

define KernelPackage/nf-nathelper-pptp/description
 Extra Netfilter (IPv4) Conntrack and NAT helpers
 Includes:
 - pptp
endef

$(eval $(call KernelPackage,nf-nathelper-pptp))

define KernelPackage/nf-nathelper-esp
  SUBMENU:=$(NF_MENU)
  TITLE:=ESP Conntrack and NAT helpers
  KCONFIG:=$(KCONFIG_NF_NATHELPER_ESP)
  FILES:=$(foreach mod,$(NF_NATHELPER_ESP-m),$(LINUX_DIR)/net/$(mod).ko)
  $(call AddDepends/ipt,+kmod-ipt-nat)
endef

define KernelPackage/nf-nathelper-esp/description
 Extra Netfilter (IPv4) Conntrack and NAT helpers
 Includes:
 - esp
endef

$(eval $(call KernelPackage,nf-nathelper-esp))


define KernelPackage/ipt-ndm-extra
  SUBMENU:=$(NF_MENU)
  TITLE:=NDM extra iptables target and matches
  KCONFIG:=$(KCONFIG_IPT_NDM_EXTRA)
  FILES:=$(foreach mod,$(IPT_NDM_EXTRA-m),$(LINUX_DIR)/net/$(mod).ko)
  $(call AddDepends/ipt,+kmod-ipt-core)
endef

define KernelPackage/ipt-ndm-extra/description
 Extra Netfilter (IPv4) iptables target and matches for NDM
 Includes:
 - connskip
 - tls
 - PPE
endef

$(eval $(call KernelPackage,ipt-ndm-extra))

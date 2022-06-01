#
# Copyright (C) 2006-2010 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

override TARGET_BUILD=
include $(INCLUDE_DIR)/prereq.mk
include $(INCLUDE_DIR)/kernel.mk
include $(INCLUDE_DIR)/host.mk
include $(INCLUDE_DIR)/ndm-packages.mk

override MAKE:=$(_SINGLE)$(SUBMAKE)
override NO_TRACE_MAKE:=$(_SINGLE)$(NO_TRACE_MAKE)

KDIR=$(KERNEL_BUILD_DIR)
DTS_DIR:=$(LINUX_DIR)/arch/$(LINUX_KARCH)/boot/dts/

IMG_PREFIX:=openwrt-$(BOARD)$(if $(SUBTARGET),-$(SUBTARGET))

ROOTFS_SIZE = $(call qstrip,$(CONFIG_TARGET_ROOTFS_SIZE))
MTD_BLOCK_SIZE ?= $(call qstrip,$(CONFIG_TARGET_MTD_BLOCK_SIZE))
NDM_DEVICE_NAME = $(shell echo $(CONFIG_TARGET_DEFAULT_PRODUCT)|sed -e 's/ /_/g')
NDM_FIRMWARE_VERSION = $(shell echo $(CONFIG_TARGET_VERSION) | \
	sed -e 's/~e/$(BSP_EPOCH)/g' \
	    -e 's/~j/$(BSP_MAJOR)/g' \
	    -e 's/~n/$(BSP_MINOR)/g' \
	    -e 's/~s/$(BSP_STAGE)/g' \
	    -e 's/~b/$(BSP_BUILD)/g' \
	    -e 's/~t/$(BSP_MAINT)/g')

NDM_FIRMWARE_DATE := $(shell date +%Y%m%d_%H%M)

NDM_HARDWARE_ID   = $(shell echo $(CONFIG_TARGET_ARCH_PACKAGES))
NDM_FIRMWARE_ID   = $(if $(filter KN-%,$(NDM_HARDWARE_ID)),$(NDM_HARDWARE_ID),$(NDM_DEVICE_NAME))
NDM_FIRMWARE_FNAME = $(NDM_FIRMWARE_DATE)_Firmware-$(NDM_FIRMWARE_ID)-$(NDM_FIRMWARE_VERSION).bin
NDM_FIRMWARE_SIZE_FNAME = $(NDM_FIRMWARE_FNAME:bin=siz)

NDM_KMOD_ONDEMAND ?= drxvi314 u200 igmpsn hw_nat whnat pppoe_pt ipv6_pt
NDM_KMOD_ONDEMAND += mt7603_ap mt7610_ap mt76x2_ap mt7613_ap mt7628_ap mt7615_ap mt7915_ap
NDM_KMOD_ONDEMAND += osal_kernel ve_vtsp_hw ve_vtsp_rt pcmdriver_slic cc
NDM_KMOD_ONDEMAND += ntc ntce nnfm rtsoc_eth ensoc_eth fastvpn vdsl zram nacct
NDM_KMOD_ONDEMAND += crypto_aes_engine eip93_cryptoapi tcrypt mt7621_eth mt7622_eth
NDM_KMOD_ONDEMAND += ensoc_flt ensoc_dmt ensoc_dsl
NDM_KMOD_ONDEMAND += ipt_NETFLOW iptable_raw

NDM_KMOD_ONDEMAND += xt_DSCP xt_statistic ip6t_ah xt_length xt_CLASSIFY xt_dscp
NDM_KMOD_ONDEMAND += xt_hl ipt_ah ipt_ECN xt_ecn xt_comment xt_string
NDM_KMOD_ONDEMAND += xt_recent xt_connbytes
NDM_KMOD_ONDEMAND += xt_NETMAP xt_u32 ip6t_MASQUERADE arptable_filter
NDM_KMOD_ONDEMAND += ipcomp ipcomp6 xfrm_ipcomp xfrm6_mode_beet ip6_vti xfrm6_tunnel
NDM_KMOD_ONDEMAND += esp6 ah6 ip_vti xfrm6_mode_tunnel xfrm6_mode_transport
NDM_KMOD_ONDEMAND += ip6table_nat xt_ipp2p xt_TEE ip6t_hbh
NDM_KMOD_ONDEMAND += xt_TEE ah4 xt_geoip xt_iprange ip6t_rt xt_addrtype
NDM_KMOD_ONDEMAND += ip6t_mh xt_IPMARK xt_ACCOUNT xt_iface xfrm4_mode_beet
NDM_KMOD_ONDEMAND += xt_time xt_DNETMAP xt_socket xt_length2 xt_fuzzy xt_ipv4options
NDM_KMOD_ONDEMAND += xt_DELUDE xt_CHAOS nf_nat_masquerade_ipv6 ip6t_NPT xt_NFQUEUE xt_NFLOG
NDM_KMOD_ONDEMAND += ip6t_ipv6header xt_hashlimit xt_LOGMARK
NDM_KMOD_ONDEMAND += ip_set_hash_ipportnet ip_set_bitmap_port xt_multiport
NDM_KMOD_ONDEMAND += ip6t_eui64 xt_DHCPMAC xt_psd xt_owner ip6t_frag
NDM_KMOD_ONDEMAND += xt_quota2 xt_pkttype xt_lscan xt_TPROXY xt_SYSRQ xt_quota
NDM_KMOD_ONDEMAND += xt_TARPIT ip_set_bitmap_ipmac ip_set_hash_netiface ip_set_hash_netport
NDM_KMOD_ONDEMAND += arp_tables ip_set_bitmap_ip xt_mac arpt_mangle xt_condition
NDM_KMOD_ONDEMAND += ip_set_hash_ipportip ip_set_hash_ipport 

NDM_KMOD_ONDEMAND += ubi ubifs

NDM_KMOD_ONDEMAND += ohci-hcd ohci-platform
NDM_KMOD_ONDEMAND += ehci-hcd ehci-platform
NDM_KMOD_ONDEMAND += xhci-hcd xhci-mtk

NDM_KMOD_ONDEMAND += nf_conntrack_sip nf_nat_sip
NDM_KMOD_ONDEMAND += nf_conntrack_ftp nf_nat_ftp
NDM_KMOD_ONDEMAND += nf_conntrack_proto_esp

NDM_KMOD_ONDEMAND += uvcvideo v4l2-common videobuf2-core
NDM_KMOD_ONDEMAND += videobuf2-memops videobuf2-vmalloc videodev
NDM_KMOD_ONDEMAND += gspca_main gspca_sonixj gspca_ov519
NDM_KMOD_ONDEMAND += i2c-dev i2c-core i2c-mux regmap-i2c
NDM_KMOD_ONDEMAND += atbm8830 av201x compat cx22702 cx231xx-alsa cx231xx-dvb
NDM_KMOD_ONDEMAND += cx231xx cx2341x cx25840 dib0070 dib7000p stb0899 dvb-usb-az6027
NDM_KMOD_ONDEMAND += dibx000_common dvb-core dvb-pll dvb-usb-cxusb dvb-usb
NDM_KMOD_ONDEMAND += dvb-usb-rtl28xxu dvb-usb-technisat-usb2 dvb-usb-tbs5520se dvb-usb-tbs5580 dvb_usb_v2 e4000 fc0012 fc0013 fc2580
NDM_KMOD_ONDEMAND += ir-jvc-decoder ir-kbd-i2c ir-lirc-codec ir-mce_kbd-decoder
NDM_KMOD_ONDEMAND += ir-nec-decoder ir-rc5-decoder ir-rc6-decoder ir-sanyo-decoder
NDM_KMOD_ONDEMAND += ir-sharp-decoder ir-sony-decoder ir-xmp-decoder lgdt3305
NDM_KMOD_ONDEMAND += lgdt3306a lgdt330x lgs8gxx lirc_dev max2165 mb86a20s
NDM_KMOD_ONDEMAND += mc44s803 media mn88472 mn88473 mt2060 mt20xx mt352
NDM_KMOD_ONDEMAND += mxl5005s qt1010 r820t rc-core rtl2830 rtl2832 rtl2832_sdr
NDM_KMOD_ONDEMAND += si2157 si2165 si2168 si2183 tda18271c2dd tda18271 tda827x
NDM_KMOD_ONDEMAND += tda8290 tda9887 tuner tuner-simple tuner-types tuner-xc2028
NDM_KMOD_ONDEMAND += tveeprom videobuf-dvb xc4000 xc5000 zl10353 v4l2-dv-timings
NDM_KMOD_ONDEMAND += videobuf-vmalloc videobuf2-v4l2 videobuf-core
NDM_KMOD_ONDEMAND += mt312 stv0288 cxd2820r cxd2841er dvb-usb-dw2102
NDM_KMOD_ONDEMAND += rc-cinergy-1400 rc-total-media-in-hand-02 rc-kworld-plus-tv-analog rc-msi-digivox-ii
NDM_KMOD_ONDEMAND += rc-digittrade rc-proteus-2309 rc-imon-pad rc-it913x-v1 rc-it913x-v2 rc-pv951
NDM_KMOD_ONDEMAND += rc-medion-x10-or2x rc-terratec-slim-2 rc-dib0700-rc5 rc-reddo rc-terratec-cinergy-c-pci
NDM_KMOD_ONDEMAND += rc-hauppauge rc-avermedia-a16d rc-pixelview-new rc-kworld-315u rc-tbs-nec rc-encore-enltv2
NDM_KMOD_ONDEMAND += rc-gadmei-rm008z rc-em-terratec rc-evga-indtube rc-avermedia-rm-ks rc-terratec-cinergy-s2-hd
NDM_KMOD_ONDEMAND += rc-real-audio-220-32-keys rc-budget-ci-old rc-pinnacle-color rc-twinhan-dtv-cab-ci rc-lirc
NDM_KMOD_ONDEMAND += rc-terratec-cinergy-xs rc-avermedia-m135a rc-pixelview-002t rc-nec-terratec-cinergy-xs rc-genius-tvgo-a11mce
NDM_KMOD_ONDEMAND += rc-snapstream-firefly rc-pinnacle-grey rc-technisat-ts35 rc-msi-tvanywhere-plus rc-manli rc-fusionhdtv-mce
NDM_KMOD_ONDEMAND += rc-gotview7135 rc-avermedia-cardbus rc-avermedia-dvbt rc-alink-dtu-m rc-videomate-m1f rc-medion-x10
NDM_KMOD_ONDEMAND += rc-behold rc-behold-columbus rc-delock-61959 rc-msi-tvanywhere rc-lme2510 rc-pctv-sedna rc-tevii-nec
NDM_KMOD_ONDEMAND += rc-ati-tv-wonder-hd-600 rc-npgtech rc-pixelview-mk12 rc-videomate-tv-pvr rc-apac-viewcomp rc-dib0700-nec
NDM_KMOD_ONDEMAND += rc-imon-mce rc-iodata-bctv7e rc-encore-enltv rc-pixelview rc-total-media-in-hand rc-asus-pc39 rc-tt-1500
NDM_KMOD_ONDEMAND += rc-dvbsky rc-twinhan1027 rc-tivo rc-leadtek-y04g0051 rc-videomate-s350 rc-streamzap rc-norwood
NDM_KMOD_ONDEMAND += rc-winfast rc-flydvb rc-cinergy rc-azurewave-ad-tu700 rc-asus-ps3-100 rc-terratec-slim
NDM_KMOD_ONDEMAND += rc-dntv-live-dvbt-pro rc-trekstor rc-anysee rc-kaiomy rc-eztv rc-winfast-usbii-deluxe rc-ati-x10
NDM_KMOD_ONDEMAND += rc-avertv-303 rc-nebula rc-avermedia-m733a-rm-k6 rc-su3000 rc-powercolor-real-angel rc-digitalnow-tinytwin
NDM_KMOD_ONDEMAND += rc-avermedia rc-kworld-pc150u rc-rc6-mce rc-dm1105-nec rc-purpletv rc-encore-enltv-fm53
NDM_KMOD_ONDEMAND += rc-adstech-dvb-t-pci rc-medion-x10-digitainer rc-msi-digivox-iii rc-flyvideo rc-pinnacle-pctv-hd
NDM_KMOD_ONDEMAND += rc-dntv-live-dvb-t rc-technisat-usb2 zl10039 si21xx stb6100 ds3000 stv0299 ts2020 stv6110 stv6110x
NDM_KMOD_ONDEMAND += stv0900 stv090x m88ds3103 stb6000 m88rs2000 cx24116 tda10023
NDM_KMOD_ONDEMAND += sch_ingress sch_codel sch_fq_codel sch_hfsc cls_fw cls_route cls_flow cls_tcindex cls_u32 em_u32
NDM_KMOD_ONDEMAND += act_mirred act_skbedit act_connmark act_ipt act_police cls_basic em_cmp em_meta em_nbyte
NDM_KMOD_ONDEMAND += em_text sch_dsmark sch_gred sch_htb sch_prio sch_red sch_sfq sch_tbf sch_teql sch_drr

# Filesystems for opkg

NDM_KMOD_ONDEMAND += isofs udf cifs nfs lockd sunrpc nfsd auth_rpcgss

# USBIP

NDM_KMOD_ONDEMAND += usbip-core vhci-hcd usbip-host

# ebtables

NDM_KMOD_ONDEMAND += ebt_802_3 ebtable_route ebtable_filter ebtable_nat ebtables ebt_among ebt_limit ebt_mark ebt_mark_m
NDM_KMOD_ONDEMAND += ebt_pkttype ebt_redirect ebt_stp ebt_vlan ebt_arp ebt_arpreply ebt_dnat ebt_ip ebt_snat ebt_ip6
NDM_KMOD_ONDEMAND += ebtable_broute

ifneq ($(CONFIG_BIG_ENDIAN),)
  JFFS2OPTS     := --pad --big-endian --squash -v
else
  JFFS2OPTS     := --pad --little-endian --squash -v
endif

ifeq ($(CONFIG_JFFS2_RTIME),y)
  JFFS2OPTS += -X rtime
endif
ifeq ($(CONFIG_JFFS2_ZLIB),y)
  JFFS2OPTS += -X zlib
endif
ifeq ($(CONFIG_JFFS2_LZMA),y)
  JFFS2OPTS += -X lzma --compression-mode=size
endif
ifneq ($(CONFIG_JFFS2_RTIME),y)
  JFFS2OPTS +=  -x rtime
endif
ifneq ($(CONFIG_JFFS2_ZLIB),y)
  JFFS2OPTS += -x zlib
endif
ifneq ($(CONFIG_JFFS2_LZMA),y)
  JFFS2OPTS += -x lzma
endif

SQUASHFSCOMP := gzip
LZMA_XZ_OPTIONS := -Xpreset 9 -Xe -Xlc 0 -Xlp 2 -Xpb 2
ifeq ($(CONFIG_SQUASHFS_LZMA),y)
  SQUASHFSCOMP := lzma $(LZMA_XZ_OPTIONS)
endif
ifeq ($(CONFIG_SQUASHFS_XZ),y)
  SQUASHFSCOMP := xz $(LZMA_XZ_OPTIONS)
endif

SQUASHFSOPT := -pf $(PLATFORM_DIR)/image/devices.list
ifneq ($(strip $(CONFIG_TARGET_ROOTFS_SQUASHFS_BLOCKSIZE)),)
  SQUASHFSOPT += -b $(CONFIG_TARGET_ROOTFS_SQUASHFS_BLOCKSIZE)k
endif

NDMSFSOPT:= -c lzma -b 131072

JFFS2_BLOCKSIZE ?= 64k 128k

fs-types-$(CONFIG_TARGET_ROOTFS_SQUASHFS) += squashfs
fs-types-$(CONFIG_TARGET_ROOTFS_NDMSFS) += ndmsfs
fs-types-$(CONFIG_TARGET_ROOTFS_JFFS2) += $(addprefix jffs2-,$(JFFS2_BLOCKSIZE))
fs-types-$(CONFIG_TARGET_ROOTFS_JFFS2_NAND) += $(addprefix jffs2-nand-,$(NAND_BLOCKSIZE))
fs-types-$(CONFIG_TARGET_ROOTFS_EXT4FS) += ext4
fs-types-$(CONFIG_TARGET_ROOTFS_ISO) += iso
TARGET_FILESYSTEMS := $(fs-types-y)

FS_64K := $(filter-out jffs2-%,$(TARGET_FILESYSTEMS)) jffs2-64k
FS_128K := $(filter-out jffs2-%,$(TARGET_FILESYSTEMS)) jffs2-128k
FS_256K := $(filter-out jffs2-%,$(TARGET_FILESYSTEMS)) jffs2-256k

define add_jffs2_mark
	echo -ne '\xde\xad\xc0\xde' >> $(1)
endef

define toupper
$(shell echo $(1) | tr '[:lower:]' '[:upper:]')
endef

define split_args
$(foreach data, \
	$(subst |,$(space),\
		$(subst $(space),^,$(1))), \
	$(call $(2),$(strip $(subst ^,$(space),$(data)))))
endef

define build_cmd
$(if $(Build/$(word 1,$(1))),,$(error Missing Build/$(word 1,$(1))))
$(call Build/$(word 1,$(1)),$(wordlist 2,$(words $(1)),$(1)))

endef

define concat_cmd
$(call split_args,$(1),build_cmd)
endef

# pad to 4k, 8k, 64k, 128k 256k and add jffs2 end-of-filesystem mark
define prepare_generic_squashfs
	$(STAGING_DIR_HOST)/bin/padjffs2 $(1) 4 8 64 128 256
endef

define size_expand
$$(($(subst k,* 1024,$(subst m, * 1024k,$(1)))))
endef

ifneq ($(CONFIG_TARGET_ROOTFS_INITRAMFS),)

  define Image/BuildKernel
		cp $(KDIR)/vmlinux.elf $(BIN_DIR)/$(IMG_PREFIX)-vmlinux.elf
		$(call Image/Build/Initramfs)
  endef

else
  define Image/BuildKernel/MkuImage
	mkimage -A $(ARCH) -O linux -T kernel -C $(1) -a $(2) -e $(3) \
		-n '$(call toupper,$(ARCH)) OpenWrt Linux-$(LINUX_VERSION)' -d $(4) $(5)
  endef

  define Image/BuildKernel/MkFIT
	$(TOPDIR)/scripts/mkits.sh \
		-D $(1) -o $(KDIR)/fit-$(1).its -k $(2) $(if $(3),-d $(3)) -C $(4) -a $(5) -e $(6) \
		-c $(if $(DEVICE_DTS_CONFIG),$(DEVICE_DTS_CONFIG),"config@1") \
		-A $(LINUX_KARCH) -v $(LINUX_VERSION)
	PATH=$(LINUX_DIR)/scripts/dtc:$(PATH) mkimage -f $(KDIR)/fit-$(1).its $(KDIR)/fit-$(1)$(7).itb
  endef

  # $(1) source dts file
  # $(2) target dtb file
  # $(3) extra CPP flags
  # $(4) extra DTC flags
  define Image/BuildDTB
	$(TARGET_CROSS)cpp -nostdinc -x assembler-with-cpp \
		-I$(DTS_DIR) \
		-I$(DTS_DIR)/include \
		-I$(LINUX_DIR)/include/ \
		-undef -D__DTS__ $(3) \
		-o $(2).tmp $(1)
	$(LINUX_DIR)/scripts/dtc/dtc -O dtb \
		-i$(dir $(1)) $(4) \
		-o $(2) $(2).tmp
	$(RM) $(2).tmp
  endef

  define Image/mkfs/jffs2/sub
		# FIXME: removing this line will cause strange behaviour in the foreach loop below
		$(STAGING_DIR_HOST)/bin/mkfs.jffs2 $(3) -e $(patsubst %k,%KiB,$(1)) -o $(KDIR)/root.jffs2-$(2) -d $(TARGET_DIR) -v 2>&1 1>/dev/null | awk '/^.+$$$$/'
		$(call add_jffs2_mark,$(KDIR)/root.jffs2-$(2))
  endef

  define Image/mkfs/jffs2/template
    Image/mkfs/jffs2-$(1) = $$(call Image/mkfs/jffs2/sub,$(1),$(1),$(JFFS2OPTS))
  endef

  define Image/mkfs/jffs2-nand/template
    Image/mkfs/jffs2-nand-$(1) = \
         $$(call Image/mkfs/jffs2/sub, \
                 $(word 2,$(subst -, ,$(1))),nand-$(1), \
                         $(JFFS2OPTS) --no-cleanmarkers --pagesize=$(word 1,$(subst -, ,$(1))))
  endef

  ifneq ($(CONFIG_TARGET_ROOTFS_JFFS2_NAND),)
    define Image/mkfs/jffs2_nand
		$(foreach SZ,$(NAND_BLOCKSIZE), $(call Image/mkfs/jffs2/sub, \
			$(word 2,$(subst :, ,$(SZ))),nand-$(subst :,-,$(SZ)), \
			$(JFFS2OPTS) --no-cleanmarkers --pagesize=$(word 1,$(subst :, ,$(SZ)))) \
		)
    endef
  endif

  $(eval $(foreach S,$(JFFS2_BLOCKSIZE),$(call Image/mkfs/jffs2/template,$(S))))
  $(eval $(foreach S,$(NAND_BLOCKSIZE),$(call Image/mkfs/jffs2-nand/template,$(S))))

  define Image/mkfs/squashfs
	$(STAGING_DIR_HOST)/bin/mksquashfs4 $(TARGET_DIR) $(KDIR)/root.squashfs -nopad -noappend -root-owned -comp $(SQUASHFSCOMP) $(SQUASHFSOPT) -processors $(N_CPU)
  endef

  define Image/mkfs/ndmsfs
	$(STAGING_DIR_HOST)/bin/mkfsndms -s $(TARGET_DIR) -o $(KDIR)/root.squashfs -c lzma -b 131072
  endef

  ifneq ($(CONFIG_TARGET_ROOTFS_UBIFS),)
    define Image/mkfs/ubifs
		$(CP) ./ubinize.cfg $(KDIR)
		$(STAGING_DIR_HOST)/bin/mkfs.ubifs $(UBIFS_OPTS) -o $(KDIR)/root.ubifs -d $(TARGET_DIR)
		(cd $(KDIR); \
		$(STAGING_DIR_HOST)/bin/ubinize $(UBINIZE_OPTS) -o $(KDIR)/root.ubi ubinize.cfg)
		$(call Image/Build,ubi)
    endef
  endif

endif

ifneq ($(CONFIG_TARGET_ROOTFS_CPIOGZ),)
  define Image/mkfs/cpiogz
		( cd $(TARGET_DIR); find . | cpio -o -H newc | gzip -9 >$(BIN_DIR)/$(IMG_PREFIX)-rootfs.cpio.gz )
  endef
endif

ifneq ($(CONFIG_TARGET_ROOTFS_TARGZ),)
  define Image/mkfs/targz
		# Preserve permissions (-p) when building as non-root user
		$(TAR) -czpf $(BIN_DIR)/$(IMG_PREFIX)-rootfs.tar.gz --numeric-owner --owner=0 --group=0 -C $(TARGET_DIR)/ .
  endef
endif

E2SIZE=$(shell echo $$(($(CONFIG_TARGET_ROOTFS_PARTSIZE)*1024)))

  define Image/mkfs/ext4
# generate an ext2 fs
	$(STAGING_DIR_HOST)/bin/genext2fs -U -b $(E2SIZE) -N $(CONFIG_TARGET_ROOTFS_MAXINODE) -d $(TARGET_DIR)/ $(KDIR)/root.ext4
# convert it to ext4
	$(STAGING_DIR_HOST)/bin/tune2fs -O extents,uninit_bg,dir_index $(KDIR)/root.ext4
# fix it up
	$(STAGING_DIR_HOST)/bin/e2fsck -fy $(KDIR)/root.ext4
	$(call Image/Build,ext4)
endef

define Image/mkfs/prepare/default
	# Use symbolic permissions to avoid clobbering SUID/SGID/sticky bits
	- $(FIND) $(TARGET_DIR) -type f -not -perm /0100 -not -name 'ssh_host*' -not -name 'shadow' -print0 | $(XARGS) -0 chmod u+rw,g+r,o+r
	- $(FIND) $(TARGET_DIR) -type f -perm /0100 -print0 | $(XARGS) -0 chmod u+rwx,g+rx,o+rx
	- $(FIND) $(TARGET_DIR) -type d -print0 | $(XARGS) -0 chmod u+rwx,g+rx,o+rx
	$(INSTALL_DIR) $(TARGET_DIR)/tmp
	chmod 1777 $(TARGET_DIR)/tmp
ifneq ($(CONFIG_PACKAGE_ndm),)
	mkdir -p $(TARGET_DIR)/etc
	$(SCRIPT_DIR)/ndm_xml.pl $(call qstrip,$(CONFIG_TARGET_ARCH_PACKAGES)) device \
		$(PACKAGE_DIR)/Packages \
		$(GIT_TAG) $(BSP_LOCAL) \
		$(NDM_PACKAGES) \
		> $(TARGET_DIR)/etc/components.xml && \
		setfattr -n user.package -v ndm $(TARGET_DIR)/etc/components.xml
	MODULES=$$$$($(TOPDIR)/scripts/mdeps.pl -b $(TARGET_DIR) -k $(LINUX_UNAME_VERSION)) || exit 1; \
	for mod in $$$${MODULES}; do \
	  echo "$(NDM_KMOD_ONDEMAND)" | grep -wq "$$$${mod}" && continue; \
	  echo "$$$${mod}" >> $(TARGET_DIR)/etc/modules.autoload; \
	done;
	CONFIG_GENERATED=false; \
	if [ -f $(TARGET_DIR)/flash/default-config_gen ]; then \
	  CONFIG_GENERATED=true; \
	  echo '!' >> $(TARGET_DIR)/flash/default-config; \
	  sed -e 's/^ /    /' $(TARGET_DIR)/flash/default-config_gen >> $(TARGET_DIR)/flash/default-config; \
	  rm -f $(TARGET_DIR)/flash/default-config_gen; \
	fi; \
	for mode in 'ap' 'client' 'repeater' 'extender'; do \
	  if [ -f $(TARGET_DIR)/flash/default-config.$$$${mode} ]; then \
	    if [ -f $(TARGET_DIR)/flash/default-config_gen_$$$${mode} ]; then \
	      CONFIG_GENERATED=true; \
	      echo '!' >> $(TARGET_DIR)/flash/default-config.$$$${mode}; \
	      sed -e 's/^ /    /' $(TARGET_DIR)/flash/default-config_gen_$$$${mode} >> \
	        $(TARGET_DIR)/flash/default-config.$$$${mode}; \
	    fi; \
	  fi; \
	  rm -f $(TARGET_DIR)/flash/default-config_gen_$$$${mode}; \
	done; \
	for i in $(TARGET_DIR)/flash/default-config*; do \
		$(SCRIPT_DIR)/ndm_include.pl $(TARGET_DIR)/flash < $$$$i > $$$${i}_inc || { rm -f $$$${i}_inc; exit 1; }; \
		mv $$$${i}_inc $$$$i; \
	done; \
	if $$$$CONFIG_GENERATED; then \
		sed -i -e 's/$$$$'"/`echo \\\r`/" -e 's/\t/    /g' $(TARGET_DIR)/flash/default-config*; \
		setfattr -n user.package -v ndm $(TARGET_DIR)/flash/default-config*; \
	fi
endif
	if [ -d $(TARGET_DIR)/lib/modules ]; then \
		find $(TARGET_DIR)/lib/modules -name modules.* -delete; \
	fi
ifneq ($(CONFIG_PACKAGE_angular-ndw),)
	HTDOCS_=$(TARGET_DIR)/usr/share/htdocs_; \
	CONSTANTS=$$$${HTDOCS_}/ndmConstants.js; \
	LANGS="$(filter-out all zz,$(patsubst lang-%,%,$(filter lang-%,$(NDM_PACKAGES))))"; \
	mkdir -p $$$${HTDOCS_}; \
	sed -i '/^window.NDM.profile.languages = {/,$$$$d' $$$${CONSTANTS}; \
	sed -i '$$$$a\' $$$${CONSTANTS}; \
	echo 'window.NDM.profile.languages = {' >> $$$${CONSTANTS}; \
	first=true; \
	for i in $$$${LANGS}; do \
		if $$$$first; then \
			printf "    \"%s\": true" $$$$i >> $$$${CONSTANTS}; \
			first=false; \
		else \
			printf ",\n    \"%s\": true" $$$$i >> $$$${CONSTANTS}; \
		fi; \
	done; \
	echo -e "\n};" >> $$$${CONSTANTS}; \
	setfattr -n user.package -v angular-ndw $$$${CONSTANTS}; \
	ln -sfn /var/run/ndmComponents.js $$$${HTDOCS_}/ndmComponents.js
endif
endef

define Image/mkfs/prepare
	$(call Image/mkfs/prepare/default)
endef


define Image/Checksum
	( cd ${BIN_DIR} ; \
		$(FIND) -maxdepth 1 -type f \! -name 'md5sums'  -printf "%P\n" | sort | xargs \
		md5sum --binary > md5sums \
	)
endef

define BuildImage/mkfs
  install: mkfs-$(1)
  .PHONY: mkfs-$(1)
  mkfs-$(1): mkfs_prepare
	$(Image/mkfs/$(1))
	$(call Build/mkfs/default,$(1))
	$(call Build/mkfs/$(1),$(1))
  $(KDIR)/root.$(1): mkfs-$(1)

endef

# Build commands that can be called from Device/* templates
define Build/uImage
	mkimage -A $(LINUX_KARCH) \
		-O linux -T kernel \
		-C $(1) -a $(KERNEL_LOADADDR) -e $(if $(KERNEL_ENTRY),$(KERNEL_ENTRY),$(KERNEL_LOADADDR)) \
		-n '$(call toupper,$(LINUX_KARCH)) OpenWrt Linux-$(LINUX_VERSION)' -d $@ $@.new
	@mv $@.new $@
endef

MKIMAGE_FIT_DTC_OPTS:=-I dts -O dtb -p 500 $(if $(CONFIG_KERNEL_MTD_NDM_DUAL_IMAGE),-b 1)

define Build/fit
	$(TOPDIR)/scripts/mkits.sh \
		-D $(DEVICE_NAME) -o $@.its -k $@ \
		$(if $(word 2,$(1)),-d $(word 2,$(1))) -C $(word 1,$(1)) \
		-a $(KERNEL_LOADADDR) -e $(if $(KERNEL_ENTRY),$(KERNEL_ENTRY),$(KERNEL_LOADADDR)) \
		-c $(if $(DEVICE_DTS_CONFIG),$(DEVICE_DTS_CONFIG),"config@1") \
		-A $(LINUX_KARCH) -v $(LINUX_VERSION)
	PATH=$(LINUX_DIR)/scripts/dtc:$(PATH) mkimage -D '$(MKIMAGE_FIT_DTC_OPTS)' -f $@.its $@.new
	@mv $@.new $@
endef

define Build/lzma
	$(STAGING_DIR_HOST)/bin/lzma e $@ -lc1 -lp2 -pb2 $(1) $@.new
	@mv $@.new $@
endef

define Build/kernel-bin
	rm -f $@
	cp $^ $@
endef

define Build/patch-cmdline
	$(STAGING_DIR_HOST)/bin/patch-cmdline $@ '$(CMDLINE)'
endef

define Build/append-kernel
	dd if=$(word 1,$^) $(if $(1),bs=$(call size_expand,$(1)) conv=sync) >> $@
endef

define Build/append-rootfs
	dd if=$(word 2,$^) $(if $(1),bs=$(call size_expand,$(1)) conv=sync) >> $@
endef

define Build/pad-extra
	dd if=/dev/zero bs=$(call size_expand,$(1)) count=1 >> $@
endef

define Build/pad-rootfs
	$(call prepare_generic_squashfs,$@ $(1))
endef

define Build/pad-offset
	let \
		size="$$(stat -c%s $@)" \
		pad="$(word 1,$(1))" \
		offset="$(word 2,$(1))" \
		pad="(pad - ((size + offset) % pad)) % pad" \
		newsize='size + pad'; \
		dd if=$@ of=$@.new bs=$$newsize count=1 conv=sync
	mv $@.new $@
endef

define Build/pad-to
	dd if=$@ of=$@.new bs=$(call size_expand,$(1)) conv=sync
	mv $@.new $@
endef

define Build/check-size
	n=$(word 1,$(1)); \
	bs=$(call size_expand,$(word 2,$(1))); \
	fs=$(call size_expand,$(word 3,$(1))); \
	if [ "$$(($$fs % $$bs))" -ne "0" ]; then \
		printf "\n$$n size (0x%08x) is not a multiple of a MTD block size (0x%08x)!\n\n" "$$fs" "$$bs" >&2; \
		rm -f $@; \
	elif [ ! -f $@ ]; then \
		printf "\nNo $@ file found.\n\n" >&2; \
		rm -f $@; \
	else \
		s=$$(stat -c%s $@); \
		if [ "$${s}" -gt "$$(($$fs))" ]; then \
			printf "\n$$n size limit (0x%08x) exceeded! Need more $$(($${s} - $$fs)) bytes!\n\n" "$$fs" >&2; \
			rm -f $@; \
		fi; \
	fi
endef

define Build/log-size
	d=$(BUILD_LOG_DIR)/sizes; \
	f=$$(basename $@); \
	f=$${f%%bin}siz; \
	mkdir -p $$d; \
	( \
		echo "Kernel:"; \
		cd $(KDIR) && stat --printf="%-20n %s\n" $(KERNEL_NAME) $(KERNEL_IMAGE); \
		echo; \
		echo "Root FS:"; \
		cd $(KDIR) && stat --printf="%-20n %s\n" root.*; \
		echo; \
		cd $(TARGET_DIR) && du --all --bytes | sort --key=2 | LC_ALL=C.UTF-8 column -t; \
	) > $$d/$$f
endef

NDMFW_DESCRIPTION = "$(call qstrip,$(CONFIG_TARGET_ARCH_PACKAGES)) $(NDM_FIRMWARE_VERSION)"

ifneq ($(wildcard $(STAGING_DIR_HOST)/bin/ndmfw),)

  NDMFW_COMPONENTS = $(subst $(space),$(comma),$(sort $(NDM_PACKAGES)))

  define Build/ndmfw-dump
	$(if $(CONFIG_TARGET_SIGN_FIRMWARE), \
		ndmfw dump \
			-B $(call size_expand,$(1)) \
			-D $(TARGET_CA_CERTS_SIGN_DIR) \
			$@ \
	)
  endef

  define Build/ndmfw-mark
	ksize="$$(stat -c%s $(word 1,$^))"; \
	ndmfw mark \
		$(if $(CONFIG_TARGET_SIGN_FIRMWARE), \
			-O $$ksize \
			-B $(call size_expand,$(1)) \
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
			-T "         components: $(call qstrip,$(NDMFW_COMPONENTS))" \
		) \
		-v $(NDMFW_DESCRIPTION) \
		-f $(CONFIG_TARGET_DEVICE_ID) \
		$@
  endef

  define Build/ndmfw-pad
	$(if $(CONFIG_TARGET_SIGN_FIRMWARE), \
		dd if=/dev/zero bs=$(call size_expand,$(1)) count=1 | tr '\000' '\377' >> $@ \
	)
  endef

  define Build/ndmfw-sign
	$(if $(CONFIG_TARGET_SIGN_FIRMWARE), \
		if [ -f "$(BUILDER_KEY)" ] && [ -f "$(BUILDER_CRT)" ]; then \
			ndmfw sign \
				-B $(call size_expand,$(1)) \
				-K "$(BUILDER_KEY)" \
				-C "$(BUILDER_CRT)" \
				$@; \
		fi \
	)
  endef

else # ($(wildcard $(STAGING_DIR_HOST)/bin/ndmfw),)

  define Build/ndmfw-dump
	@true
  endef

  define Build/ndmfw-mark
	zyimage \
		-d $(CONFIG_TARGET_DEVICE_ID) \
		-v $(NDMFW_DESCRIPTION) \
		$@
  endef

  define Build/ndmfw-pad
	@true
  endef

  define Build/ndmfw-sign
	@true
  endef

endif # ($(wildcard $(STAGING_DIR_HOST)/bin/ndmfw),)


define Device/Init
  PROFILES := $(PROFILE)
  DEVICE_NAME := $(1)
  KERNEL:=
  KERNEL_INITRAMFS = $$(KERNEL)
  KERNEL_SIZE:=
  CMDLINE:=

  IMAGE_PREFIX := $(IMG_PREFIX)-$(1)
  IMAGE_NAME = $$(IMAGE_PREFIX)-$$(1)-$$(2)
  KERNEL_PREFIX = $(1)
  KERNEL_SUFFIX := -kernel.bin
  KERNEL_IMAGE = $$(KERNEL_PREFIX)$$(KERNEL_SUFFIX)
  KERNEL_INITRAMFS_PREFIX = $$(IMAGE_PREFIX)-initramfs
  KERNEL_INITRAMFS_IMAGE = $$(KERNEL_INITRAMFS_PREFIX)$$(KERNEL_SUFFIX)
  KERNEL_INSTALL :=
  KERNEL_NAME := vmlinux
  KERNEL_SIZE :=

  DEVICE_DTS_CONFIG :=

  FILESYSTEMS := $(TARGET_FILESYSTEMS)
endef

define Device/ExportVar
  $(1) : $(2):=$$($(2))

endef
define Device/Export
  $(foreach var,$(DEVICE_VARS) DEVICE_DTS_CONFIG DEVICE_NAME KERNEL,$(call Device/ExportVar,$(1),$(var)))
  $(1) : FILESYSTEM:=$(2)
endef

define Device/Check
  _TARGET = $$(if $$(filter $(PROFILE),$$(PROFILES)),install,install-disabled)
endef

define Device/Build/initramfs
  $$(_TARGET): $(BIN_DIR)/$$(KERNEL_INITRAMFS_IMAGE)

  $(BIN_DIR)/$$(KERNEL_INITRAMFS_IMAGE): $(KDIR)/$$(KERNEL_INITRAMFS_IMAGE)
	cp $$^ $$@

  $(KDIR)/$$(KERNEL_INITRAMFS_IMAGE): $(KDIR)/$$(KERNEL_NAME)-initramfs
	@rm -f $$@
	$$(call concat_cmd,$$(KERNEL_INITRAMFS))
endef

define Device/Build/check_size
	@[ $(call size_expand,$(1)) -ge "$$(stat -c%s $@)" ] || { \
		echo "WARNING: Image file $@ is too big" >&2; \
		rm -f $@; \
	}
endef

define Device/Build/kernel
  $$(_TARGET): $$(if $$(KERNEL_INSTALL),$(BIN_DIR)/$$(KERNEL_IMAGE))
  $(BIN_DIR)/$$(KERNEL_IMAGE): $(KDIR)/$$(KERNEL_IMAGE)
	cp $$^ $$@
  $(KDIR)/$$(KERNEL_IMAGE): $(KDIR)/$$(KERNEL_NAME)
	@rm -f $$@
	$$(call concat_cmd,$$(KERNEL))
	$$(if $$(KERNEL_SIZE),$$(call Device/Build/check_size,$$(KERNEL_SIZE)))
endef

define Device/Build/image
  $$(_TARGET): $(BIN_DIR)/$(call IMAGE_NAME,$(1),$(2))
  $(eval $(call Device/Export,$(KDIR)/$(KERNEL_IMAGE),$(1)))
  $(eval $(call Device/Export,$(KDIR)/$(KERNEL_INITRAMFS_IMAGE),$(1)))
  $(eval $(call Device/Export,$(KDIR)/tmp/$(call IMAGE_NAME,$(1),$(2)),$(1)))
  $(KDIR)/tmp/$(call IMAGE_NAME,$(1),$(2)): $(KDIR)/$$(KERNEL_IMAGE) $(KDIR)/root.$(1)
	@rm -f $$@
	[ -f $$(word 1,$$^) -a -f $$(word 2,$$^) ]
	$$(call concat_cmd,$(if $(IMAGE/$(2)/$(1)),$(IMAGE/$(2)/$(1)),$(IMAGE/$(2))))

  .IGNORE: $(BIN_DIR)/$(call IMAGE_NAME,$(1),$(2))
  $(BIN_DIR)/$(call IMAGE_NAME,$(1),$(2)): $(KDIR)/tmp/$(call IMAGE_NAME,$(1),$(2))
	cp $$^ $$@

endef

define Device/Build
  $(if $(CONFIG_TARGET_ROOTFS_INITRAMFS),$(call Device/Build/initramfs,$(1)))
  $(call Device/Build/kernel,$(1))

  $$(eval $$(foreach image,$$(IMAGES), \
    $$(foreach fs,$$(filter $(TARGET_FILESYSTEMS),$$(FILESYSTEMS)), \
      $$(call Device/Build/image,$$(fs),$$(image),$(1)))))
endef

define Device
  $(call Device/Init,$(1))
  $(call Device/Default,$(1))
  $(call Device/Check,$(1))
  $(call Device/$(1),$(1))
  $(call Device/Build,$(1))

endef

define BuildImage

  download:
  prepare:
  compile:
  clean:
  image_prepare:

  ifeq ($(IB),)
    .PHONY: download prepare compile clean image_prepare mkfs_prepare kernel_prepare install
    compile:
		$(call Build/Compile)

    clean:
		$(call Build/Clean)

    image_prepare: compile
		mkdir -p $(KDIR)/tmp
		$(call Image/Prepare)
  else
    image_prepare: compile
		mkdir -p $(KDIR)/tmp
  endif

  mkfs_prepare: image_prepare
	$(call Image/mkfs/prepare)

  kernel_prepare: mkfs_prepare
	$(call Image/BuildKernel)
	$(call Image/InstallKernel)

  $(foreach device,$(TARGET_DEVICES),$(call Device,$(device)))
  $(foreach fs,$(TARGET_FILESYSTEMS),$(call BuildImage/mkfs,$(fs)))

  install: kernel_prepare
	$(call Image/mkfs/cpiogz)
	$(call Image/mkfs/targz)
	$(foreach fs,$(TARGET_FILESYSTEMS),
		$(call Image/Build,$(fs))
	)
	$(call Image/mkfs/ubifs)
	$(call Image/Checksum)
ifneq ($(EXTERNAL_BIN),)
	mv $(BIN_DIR)/$(NDM_FIRMWARE_FNAME) $(EXTERNAL_BIN)
endif

endef

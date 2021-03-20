#
# Copyright (C) 2006-2011 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

define KernelPackage/fs-netfs
  SUBMENU:=$(FS_MENU)
  TITLE:=Network filesystems support
  KCONFIG:=CONFIG_NETWORK_FILESYSTEMS=y
endef

$(eval $(call KernelPackage,fs-netfs))

define KernelPackage/fs-autofs4
  SUBMENU:=$(FS_MENU)
  TITLE:=AUTOFS4 filesystem support
  KCONFIG:=CONFIG_AUTOFS4_FS 
  FILES:=$(LINUX_DIR)/fs/autofs4/autofs4.ko
  AUTOLOAD:=$(call AutoLoad,30,autofs4)
endef

define KernelPackage/fs-autofs4/description
  Kernel module for AutoFS4 support
endef

$(eval $(call KernelPackage,fs-autofs4))


define KernelPackage/fs-btrfs
  SUBMENU:=$(FS_MENU)
  TITLE:=BTRFS filesystem support
  DEPENDS:=+kmod-lib-crc32c +kmod-lib-lzo +kmod-lib-zlib
  KCONFIG:=\
	CONFIG_BTRFS_FS \
	CONFIG_BTRFS_FS_POSIX_ACL=n \
	CONFIG_BTRFS_FS_CHECK_INTEGRITY=n
  FILES:=\
	$(LINUX_DIR)/fs/btrfs/btrfs.ko
  AUTOLOAD:=$(call AutoLoad,30,btrfs,1)
endef

define KernelPackage/fs-btrfs/description
  Kernel module for BTRFS support
endef

$(eval $(call KernelPackage,fs-btrfs))


define KernelPackage/fs-cifs
  SUBMENU:=$(FS_MENU)
  TITLE:=CIFS support
  KCONFIG:= \
	CONFIG_CIFS \
	CONFIG_CIFS_DFS_UPCALL=n \
	CONFIG_CIFS_UPCALL=n \
	CONFIG_CIFS_STATS=n \
	CONFIG_CIFS_WEAK_PW_HASH=y \
	CONFIG_CIFS_XATTR=n \
	CONFIG_CIFS_DEBUG2=n
  FILES:=$(LINUX_DIR)/fs/cifs/cifs.ko
  $(call AddDepends/nls)
  DEPENDS+= \
    +kmod-fs-netfs \
    +kmod-crypto-arc4 \
    +kmod-crypto-hmac \
    +kmod-crypto-md5 \
    +kmod-crypto-md4 \
    +kmod-crypto-des \
    +kmod-crypto-ecb
endef

define KernelPackage/fs-cifs/description
 Kernel module for CIFS support
endef

$(eval $(call KernelPackage,fs-cifs))


define KernelPackage/fs-exportfs
  SUBMENU:=$(FS_MENU)
  TITLE:=exportfs kernel server support
  KCONFIG:=CONFIG_EXPORTFS
  FILES=$(LINUX_DIR)/fs/exportfs/exportfs.ko
endef

define KernelPackage/fs-exportfs/description
 Kernel module for exportfs. Needed for some other modules.
endef

$(eval $(call KernelPackage,fs-exportfs))

define KernelPackage/fs-hfs
  SUBMENU:=$(FS_MENU)
  TITLE:=HFS+ filesystem support
  KCONFIG:=CONFIG_HFS_FS
  FILES:=$(LINUX_DIR)/fs/hfs/hfs.ko
  AUTOLOAD:=$(call AutoLoad,30,hfs)
  $(call AddDepends/nls)
endef

define KernelPackage/fs-hfs/description
 Kernel module for HFS filesystem support
endef

$(eval $(call KernelPackage,fs-hfs))


define KernelPackage/fs-hfsplus
  SUBMENU:=$(FS_MENU)
  TITLE:=HFS+ filesystem support
  KCONFIG:=CONFIG_HFSPLUS_FS
  FILES:=$(LINUX_DIR)/fs/hfsplus/hfsplus.ko
  AUTOLOAD:=$(call AutoLoad,30,hfsplus)
  $(call AddDepends/nls,utf8)
endef

define KernelPackage/fs-hfsplus/description
 Kernel module for HFS+ filesystem support
endef

$(eval $(call KernelPackage,fs-hfsplus))


define KernelPackage/fs-isofs
  SUBMENU:=$(FS_MENU)
  TITLE:=ISO9660 filesystem support
  DEPENDS:=+kmod-lib-zlib
  KCONFIG:=CONFIG_ISO9660_FS=m CONFIG_JOLIET=y CONFIG_ZISOFS=n
  FILES:=$(LINUX_DIR)/fs/isofs/isofs.ko
  AUTOLOAD:=$(call AutoLoad,30,isofs)
  $(call AddDepends/nls)
endef

define KernelPackage/fs-isofs/description
 Kernel module for ISO9660 filesystem support
endef

$(eval $(call KernelPackage,fs-isofs))


define KernelPackage/fs-minix
  SUBMENU:=$(FS_MENU)
  TITLE:=Minix filesystem support
  KCONFIG:=CONFIG_MINIX_FS
  FILES:=$(LINUX_DIR)/fs/minix/minix.ko
  AUTOLOAD:=$(call AutoLoad,30,minix)
endef

define KernelPackage/fs-minix/description
 Kernel module for Minix filesystem support
endef

$(eval $(call KernelPackage,fs-minix))


define KernelPackage/fs-msdos
  SUBMENU:=$(FS_MENU)
  TITLE:=MSDOS filesystem support
  KCONFIG:=CONFIG_MSDOS_FS
  FILES:=$(LINUX_DIR)/fs/fat/msdos.ko
  AUTOLOAD:=$(call AutoLoad,40,msdos)
  $(call AddDepends/nls)
endef

define KernelPackage/fs-msdos/description
 Kernel module for MSDOS filesystem support
endef

$(eval $(call KernelPackage,fs-msdos))


define KernelPackage/fs-nfs
  SUBMENU:=$(FS_MENU)
  TITLE:=NFS filesystem support
  DEPENDS:=+kmod-fs-nfs-common +kmod-fs-netfs +kmod-fs-sunrpc-auth-rpcgss
  KCONFIG:= \
	CONFIG_NFS_FS \
	CONFIG_NFS_V3=y \
	CONFIG_NFS_V3_ACL=n \
	CONFIG_NFS_USE_LEGACY_DNS=n \
	CONFIG_NFS_USE_NEW_IDMAPPER=n
  FILES:= \
	$(LINUX_DIR)/fs/nfs/nfs.ko
endef

define KernelPackage/fs-nfs/description
 Kernel module for NFS support
endef

define KernelPackage/fs-nfs/config
  if PACKAGE_kmod-fs-nfs
       config KERNEL_NFS_V4
               bool "Support NFSv4 in NFS client"
               default n
               help
                 Select this option to support NFSv4 in the NFS server
  endif
endef

$(eval $(call KernelPackage,fs-nfs))


define KernelPackage/fs-nfs-common
  SUBMENU:=$(FS_MENU)
  TITLE:=Common NFS filesystem modules
  KCONFIG:= \
	CONFIG_LOCKD \
	CONFIG_SUNRPC
  FILES:= \
	$(LINUX_DIR)/fs/lockd/lockd.ko \
	$(LINUX_DIR)/net/sunrpc/sunrpc.ko \
	$(LINUX_DIR)/fs/nfs_common/grace.ko
endef

$(eval $(call KernelPackage,fs-nfs-common))

define KernelPackage/fs-sunrpc-auth-rpcgss
  SUBMENU:=$(FS_MENU)
  TITLE:=GSS authentication for SUN RPC
  DEPENDS:=+kmod-fs-nfs-common
  KCONFIG:= \
	CONFIG_SUNRPC_GSS \
	CONFIG_RPCSEC_GSS_KRB5=n
  FILES:= \
	$(LINUX_DIR)/lib/oid_registry.ko \
	$(LINUX_DIR)/net/sunrpc/auth_gss/auth_rpcgss.ko
  AUTOLOAD:=$(call AutoLoad,30,oid_registry auth_rpcgss)
endef

$(eval $(call KernelPackage,fs-sunrpc-auth-rpcgss))

define KernelPackage/fs-nfsd
  SUBMENU:=$(FS_MENU)
  TITLE:=NFS kernel server support
  DEPENDS:=+kmod-fs-nfs-common +kmod-fs-exportfs +kmod-fs-netfs +kmod-fs-sunrpc-auth-rpcgss
  KCONFIG:= \
	CONFIG_NFSD \
	CONFIG_NFSD_V3=y \
	CONFIG_NFSD_V3_ACL=n \
	CONFIG_NFSD_FAULT_INJECTION=n
  FILES:=$(LINUX_DIR)/fs/nfsd/nfsd.ko
endef

define KernelPackage/fs-nfsd/description
 Kernel module for NFS kernel server support
endef

define KernelPackage/fs-nfsd/config
  if PACKAGE_kmod-fs-nfsd
       config KERNEL_NFSD_V4
               bool "Support NFSv4 in NFS server"
               default n
               help
                 Select this option to support NFSv4 in the NFS server
  endif
endef

$(eval $(call KernelPackage,fs-nfsd))


define KernelPackage/fs-ntfs
  SUBMENU:=$(FS_MENU)
  TITLE:=NTFS filesystem support
  KCONFIG:=CONFIG_NTFS_FS
  FILES:=$(LINUX_DIR)/fs/ntfs/ntfs.ko
  AUTOLOAD:=$(call AutoLoad,30,ntfs)
  $(call AddDepends/nls)
endef

define KernelPackage/fs-ntfs/description
 Kernel module for NTFS filesystem support
endef

$(eval $(call KernelPackage,fs-ntfs))


define KernelPackage/fs-reiserfs
  SUBMENU:=$(FS_MENU)
  TITLE:=ReiserFS filesystem support
  KCONFIG:=CONFIG_REISERFS_FS
  FILES:=$(LINUX_DIR)/fs/reiserfs/reiserfs.ko
  AUTOLOAD:=$(call AutoLoad,30,reiserfs,1)
endef

define KernelPackage/fs-reiserfs/description
 Kernel module for ReiserFS support
endef

$(eval $(call KernelPackage,fs-reiserfs))


define KernelPackage/fs-udf
  SUBMENU:=$(FS_MENU)
  TITLE:=UDF filesystem support
  KCONFIG:=CONFIG_UDF_FS=m CONFIG_UDF_NLS=y
  FILES:=$(LINUX_DIR)/fs/udf/udf.ko
  AUTOLOAD:=$(call AutoLoad,30,udf)
  DEPENDS:=+kmod-lib-crc-itu-t
  $(call AddDepends/nls)
endef

define KernelPackage/fs-udf/description
 Kernel module for UDF filesystem support
endef

$(eval $(call KernelPackage,fs-udf))


define KernelPackage/fs-vfat
  SUBMENU:=$(FS_MENU)
  TITLE:=VFAT filesystem support
  KCONFIG:= \
	CONFIG_FAT_FS \
	CONFIG_VFAT_FS
  FILES:= \
	$(LINUX_DIR)/fs/fat/fat.ko \
	$(LINUX_DIR)/fs/fat/vfat.ko
  AUTOLOAD:=$(call AutoLoad,30,fat vfat)
  $(call AddDepends/nls,cp437 iso8859-1 utf8)
endef

define KernelPackage/fs-vfat/description
 Kernel module for VFAT filesystem support
endef

$(eval $(call KernelPackage,fs-vfat))


define KernelPackage/fs-xfs
  SUBMENU:=$(FS_MENU)
  TITLE:=XFS filesystem support
  KCONFIG:=CONFIG_XFS_FS
  DEPENDS:= +kmod-fs-exportfs
  FILES:=$(LINUX_DIR)/fs/xfs/xfs.ko
  AUTOLOAD:=$(call AutoLoad,30,xfs,1)
endef

define KernelPackage/fs-xfs/description
 Kernel module for XFS support
endef

$(eval $(call KernelPackage,fs-xfs))

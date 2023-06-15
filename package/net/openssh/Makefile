#
# Copyright (C) 2022 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=openssh
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Build/Compile
endef

define Package/openssh-sftp-server
  SUBMENU:=SSH
  CATEGORY:=Network
  TITLE:=OpenSSH SFTP server
  DEPENDS:=+libc +SSP_SUPPORT:libssp +libopenssl +zlib +libndm +libndmacl_stub
  DISABLE_RSTRIP:=y
endef

define Package/openssh-sftp-server/install
	if [ -d ./files-openssh-sftp-server ]; then \
		$(CP) ./files-openssh-sftp-server/* $(1); \
	fi
endef

$(eval $(call BuildPackage,openssh-sftp-server))

define Package/openssh-ssh-client
  SUBMENU:=SSH
  CATEGORY:=Network
  TITLE:=OpenSSH SSH client
  DEPENDS:=+libc +SSP_SUPPORT:libssp +libopenssl +zlib +libndm +libndmacl_stub
  DISABLE_RSTRIP:=y
endef

define Package/openssh-ssh-client/install
	if [ -d ./files-openssh-ssh-client ]; then \
		$(CP) ./files-openssh-ssh-client/* $(1); \
	fi
endef

$(eval $(call BuildPackage,openssh-ssh-client))

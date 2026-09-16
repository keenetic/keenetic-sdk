define KernelPackage/crypto-user-nl
  SUBMENU:=$(CRYPTO_MENU)
  TITLE:=Netlink-based CryptoAPI configuration module
  DEPENDS:=+kmod-crypto-core
  KCONFIG:=CONFIG_CRYPTO_USER
  FILES:=$(LINUX_DIR)/crypto/crypto_user.ko
  AUTOLOAD:=$(call AutoLoad,09,crypto_user-nl)
endef

$(eval $(call KernelPackage,crypto-user-nl))

define KernelPackage/crypto-pcrypt
  SUBMENU:=$(CRYPTO_MENU)
  TITLE:=Parallel CryptoAPI module
  DEPENDS:=+kmod-crypto-manager
  KCONFIG:=CONFIG_CRYPTO_PCRYPT
  FILES:=$(LINUX_DIR)/crypto/pcrypt.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,09,pcrypt)
endef

$(eval $(call KernelPackage,crypto-pcrypt))

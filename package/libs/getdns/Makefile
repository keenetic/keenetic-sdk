# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=getdns
PKG_VERSION:=1.7.0

PKG_LICENSE:=BSD-3-Clause
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=Jonathan Underwood <jonathan.underwood@gmail.com>

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://getdnsapi.net/dist/
PKG_HASH:=ea8713ce5e077ac76b1418ceb6afd25e6d4e39e9600f6f5e81d3a3a13a60f652

CMAKE_INSTALL:=1
PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/getdns/Default
	TITLE:=getdns
	URL:=https://getdnsapi.net/
endef

define Package/getdns
	$(call Package/getdns/Default)
	SECTION:=libs
	CATEGORY:=Libraries
	TITLE+= (library)
	DEPENDS+= +libopenssl
	MENU:=1
endef

define Package/getdns/description
	This package contains the getdns library (libgetdns).
	This package also contains the "getdns_query" command line wrapper for getdns exposing the features of this implementation (both in the official API and the additional API functions).
endef

# CMAKE options for GetDNS are described in this document:
# https://getdnsapi.net/quick-start/cmake-quick-start/
CMAKE_OPTIONS += -DBUILD_LIBEV=OFF
CMAKE_OPTIONS += -DBUILD_LIBEVENT2=OFF
CMAKE_OPTIONS += -DBUILD_LIBUV=OFF

CMAKE_OPTIONS += -DENABLE_STUB_ONLY=ON
CMAKE_OPTIONS += -DUSE_LIBIDN2=OFF

# getdns will use libbsd for the functions inet_pton, inet_ntop, strlcpy if
# present, otherwise it will use builtin code for these functions. In order to
# force the use of the built in code and remove the libbsd dependency disable
# the test for libbsd.
CMAKE_OPTIONS += -DBSD_LIBRARY=OFF
CMAKE_OPTIONS += -DBUILD_TESTING=OFF
CMAKE_OPTIONS += -DENABLE_SHARED=OFF
CMAKE_OPTIONS += -DENABLE_STATIC=ON
CMAKE_OPTIONS += -DENABLE_DRAFT_MDNS_SUPPORT=OFF
CMAKE_OPTIONS += -DENABLE_EDNS_COOKIES=OFF
CMAKE_OPTIONS += -DENABLE_TCP_FAST_OPEN=OFF
CMAKE_OPTIONS += -DBUILD_GETDNS_QUERY=OFF
CMAKE_OPTIONS += -DBUILD_GETDNS_SERVER_MON=OFF
CMAKE_OPTIONS += -DENABLE_GOST=OFF
CMAKE_OPTIONS += -DENABLE_DSA=OFF

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include/getdns
	$(CP) $(PKG_INSTALL_DIR)/usr/include/getdns/getdns*.h $(1)/usr/include/getdns
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libgetdns.a $(1)/usr/lib/
	$(INSTALL_DIR) $(1)/usr/lib/pkgconfig
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/pkgconfig/getdns*.pc $(1)/usr/lib/pkgconfig/
endef

$(eval $(call BuildPackage,getdns))

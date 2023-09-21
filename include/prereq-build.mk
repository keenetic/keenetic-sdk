# 
# Copyright (C) 2006-2012 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/prereq.mk
include $(INCLUDE_DIR)/host.mk
include $(INCLUDE_DIR)/host-build.mk

PKG_NAME:=Build dependency

define Require/non-root
	[ "$$(shell whoami)" != "root" ]
endef
$(eval $(call Require,non-root, \
	Please do not compile as root. \
))

# Required for the toolchain
define Require/working-make
	$(MAKE) -v | awk '($$$$1 == "GNU") && ($$$$2 == "Make") && ($$$$3 >= "3.81") { print "ok" }' | grep ok > /dev/null
endef

$(eval $(call Require,working-make, \
	Please install GNU make v3.81 or later. (This version has bugs) \
))

define Require/case-sensitive-fs
	rm -f $(TMP_DIR)/test.*
	touch $(TMP_DIR)/test.fs
	[ \! -f $(TMP_DIR)/test.FS ]
endef

$(eval $(call Require,case-sensitive-fs, \
	OpenWrt can only be built on a case-sensitive filesystem \
))

define Require/getopt
	getopt --help 2>&1 | grep long >/dev/null
endef
$(eval $(call Require,getopt, \
	Please install GNU getopt \
))

define Require/fileutils
	gcp --help || cp --help
endef
$(eval $(call Require,fileutils, \
	Please install GNU fileutils \
))

define Require/working-gcc
	echo 'int main(int argc, char **argv) { return 0; }' | \
		gcc -x c -o $(TMP_DIR)/a.out -
endef

$(eval $(call Require,working-gcc, \
	Please install the GNU C Compiler (gcc). \
))

define Require/working-g++
	echo 'int main(int argc, char **argv) { return 0; }' | \
		g++ -x c++ -o $(TMP_DIR)/a.out - -lstdc++ && \
		$(TMP_DIR)/a.out
endef

$(eval $(call Require,working-g++, \
	Please install the GNU C++ Compiler (g++). \
))

ifneq ($(HOST_STATIC_LINKING),)
  define Require/working-gcc-static
	echo 'int main(int argc, char **argv) { return 0; }' | \
		gcc -x c $(HOST_STATIC_LINKING) -o $(TMP_DIR)/a.out -
  endef

  $(eval $(call Require,working-gcc-static, \
    Please install the static libc development package (glibc-static on CentOS/Fedora/RHEL). \
  ))

  define Require/working-g++-static
	echo 'int main(int argc, char **argv) { return 0; }' | \
		g++ -x c++ $(HOST_STATIC_LINKING) -o $(TMP_DIR)/a.out - -lstdc++ && \
		$(TMP_DIR)/a.out
  endef

  $(eval $(call Require,working-g++-static, \
	Please install the static libstdc++ development package (libstdc++-static on CentOS/Fedora/RHEL). \
  ))
endif

define Require/ncurses
	echo 'int main(int argc, char **argv) { initscr(); return 0; }' | \
		gcc -include ncurses.h -x c -o $(TMP_DIR)/a.out - -lncurses
endef

$(eval $(call Require,ncurses, \
	Please install ncurses. (Missing libncurses.so or ncurses.h) \
))

define Require/libcrypto
	echo 'int main(int argc, char **argv) { ERR_clear_error(); return 0; }' | \
		gcc -include openssl/err.h -x c -o $(TMP_DIR)/a.out - -lcrypto
endef

$(eval $(call Require,libcrypto, \
	Please install the OpenSSL development package. (Missing libcrypto.so or headers). \
))

define Require/zlib
	echo 'int main(int argc, char **argv) { gzdopen(0, "rb"); return 0; }' | \
		gcc -include zlib.h -x c -o $(TMP_DIR)/a.out - -lz
endef

$(eval $(call Require,zlib, \
	Please install zlib. (Missing libz.so or zlib.h) \
))

ifneq ($(HOST_STATIC_LINKING),)
  define Require/zlib-static
	echo 'int main(int argc, char **argv) { gzdopen(0, "rb"); return 0; }' | \
		gcc -include zlib.h -x c $(HOST_STATIC_LINKING) -o $(TMP_DIR)/a.out - -lz
  endef

  $(eval $(call Require,zlib-static, \
	Please install a static zlib. (zlib-static on CentOS/Fedora/RHEL). \
  ))
endif

$(eval $(call RequireCommand,gawk, \
	Please install GNU awk. \
))

$(eval $(call RequireCommand,unzip, \
	Please install unzip. \
))

$(eval $(call RequireCommand,bzip2, \
	Please install bzip2. \
))

$(eval $(call RequireCommand,patch, \
	Please install patch. \
))

$(eval $(call RequireCommand,perl, \
	Please install perl. \
))

$(eval $(call RequireCommand,python, \
	Please install python. \
))

$(eval $(call RequireCommand,curl, \
	Please install curl. \
))

$(eval $(call RequireCommand,jq, \
	Please install jq. \
))

define Require/git
	git --version | awk '($$$$1 == "git") && ($$$$2 == "version") && ($$$$3 >= "1.6.5") { print "ok" }' | grep ok > /dev/null
endef

$(eval $(call Require,git, \
	Please install git (git-core) v1.6.5 or later. \
))

define Require/gnutar
	$(TAR) --version 2>&1 | grep GNU > /dev/null
endef

$(eval $(call Require,gnutar, \
	Please install GNU tar. \
))

$(eval $(call RequireCommand,svn, \
	Please install the subversion client. \
))

define Require/gnu-find
	$(FIND) --version 2>/dev/null
endef

$(eval $(call Require,gnu-find, \
	Please install GNU find \
))

define Require/getopt-extended
	getopt --long - - >/dev/null
endef

$(eval $(call Require,getopt-extended, \
	Please install an extended getopt version that supports --long \
))

define Require/perl-data-dumper
	perl -mData::Dumper -e1 > /dev/null
endef

$(eval $(call Require,perl-data-dumper, \
	Please install the Perl Data::Dumper module (perl-Data-Dumper on CentOS/Fedora/RHEL). \
))

define Require/perl-digest-md5
	perl -mDigest::MD5 -e1 > /dev/null
endef

$(eval $(call Require,perl-digest-md5, \
	Please install the Perl Digest::MD5 module (perl-Digest-MD5 on CentOS/Fedora/RHEL). \
))

define Require/perl-json
	perl -mJSON -e1 > /dev/null
endef

$(eval $(call Require,perl-json, \
	Please install the Perl JSON module (perl-JSON on CentOS/Fedora/RHEL and libjson-perl on Debian/Ubuntu). \
))

define Require/perl-html-entries
	perl -mHTML::Entities -e1 > /dev/null
endef

$(eval $(call Require,perl-html-entries, \
	Please install the Perl HTML::Entities module (perl-HTML-Parser on CentOS/Fedora/RHEL and libhtml-parser-perl on Debian/Ubuntu). \
))

define Require/python3-distutils
	"$$$$(python --version | sed -e 's/^Python \(3\)\..*/\1/')" != "3" || python -c "import distutils.core" > /dev/null 2>&1
endef

$(eval $(call Require,python3-distutils, \
	Please install the Python 3 distutils module (python3-distutils-extra on CentOS/Fedora/RHEL and python3-distutils on Debian/Ubuntu). \
))

$(eval $(call RequireCommand,xxd, \
	Please install xxd (vim-common). \
))

$(eval $(call RequireCommand,attr, \
	Please install attr. \
))

$(eval $(call RequireCommand,bc, \
	Please install bc. \
))

$(eval $(call RequireCommand,file, \
	Please install file. \
))

$(eval $(call RequireCommand,openssl, \
	Please install OpenSSL commandline utility. \
))

$(eval $(call RequireCommand,gperf, \
	Please install gperf. \
))

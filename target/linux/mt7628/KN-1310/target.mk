#
# Copyright (C) 2021 Keenetic Limited
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

SUBTARGET:=KN-1310
DESCRIPTION:=Lite
BOARD_CPPFLAGS += -D__KN_1310__
DEFAULT_PACKAGES += ndm-mod-interface-extras
FEATURES += ndw2_wizard no_dpn old_model_2 old_modes

define Target/Description
	Build firmware images for KN-1310
endef


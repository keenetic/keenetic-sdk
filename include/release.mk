ifeq ($(IB),)
GIT_TAG := $(shell \
    git -C $(TOPDIR) describe 2>/dev/null | \
    grep '^[0-9]\.[0-9]\+\.[A-E]\.[0-9]\+\.[0-9]\+' | \
    sed -e 's/\.\([0-9]\+\)$$/.\1-0/' \
        -e 's/\.\([0-9]\+\)-\([0-9\+]\)-g/.\1-0-\2-/' \
        -e 's/-g/-/')

ifeq ($(GIT_TAG),)
GIT_TAG := 0.00.A.0.0-0
endif

BSP_CDATE := $(shell \
    git show -s --pretty="format:%cD" | \
    cut -d' ' -f 2,3,4)
BSP_LOCAL := $(shell $(TOPDIR)/scripts/getlocalver.sh)
else
include $(TOPDIR)/git.tags
endif

BSP_EPOCH := $(shell echo $(GIT_TAG) | cut -d '.' -f 1)
BSP_MAJOR := $(shell echo $(GIT_TAG) | cut -d '.' -f 2)
BSP_STAGE := $(shell echo $(GIT_TAG) | cut -d '.' -f 3)
BSP_MINOR := $(shell echo $(GIT_TAG) | cut -d '.' -f 4 | \
    sed -e 's/^0*\(.\)/\1/')
BSP_MAINT := $(shell echo $(GIT_TAG) | cut -d '.' -f 5 | \
    sed -e 's/-.*//')
BSP_BUILD := $(shell echo $(GIT_TAG) | cut -d '.' -f 5 | \
    sed -e 's/[^-]*-\([^-]*\).*/\1/')
BSP_EXACT := $(shell echo $(GIT_TAG) | cut -d '.' -f 5 | \
    grep -o '[0-9]\+-[0-9a-f]\{4,\}')
ifeq ($(BSP_EXACT),)
BSP_EXACT := $(shell git log -1 --pretty=format:0-%h)
endif

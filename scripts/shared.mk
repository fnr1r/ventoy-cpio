ARCHES_X86 := i386 x86_64
ARCHES_ARM := aarch64
ARCHES_MIPS := mips64el
ARCHES_ALL := $(ARCHES_X86) $(ARCHES_ARM) $(ARCHES_MIPS)

ARCHES_WITHOUT_I386 := x86_64 $(ARCHES_ARM) $(ARCHES_MIPS)
ARCHES_WITHOUT_MIPS := $(ARCHES_X86) $(ARCHES_ARM)

CURL_FLAGS ?= -L -s
XZ_FLAGS ?= -e -9

# decided to use curl for downloads d:
#WGET_FLAGS ?= -q
# wget $(WGET_FLAGS) -O $$@ $1

# might be useful
RANDOM_STRING = $(shell hexdump -v -n 16 -e '4 /4  "%08X" 1 "\n"' /dev/urandom)

# default to building for all targets
ifndef TARGETS
TARGETS := $(ARCHES_ALL)
endif

export TARGETS

# automatically import shared_$NAME
ifndef _NO_AUTOIMPORT
$(eval $(foreach f,\
	$(SCRIPTS_DIR)/shared_$(notdir $(firstword $(MAKEFILE_LIST))),\
	$(if $(shell if [ -f "$f" ]; then echo "$f"; fi),include $f,)\
))
endif

uppercase = $(shell echo "$1" | tr '[:lower:]' '[:upper:]')

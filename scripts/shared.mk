ARCHES_X86 := i386 x86_64
ARCHES_ARM := aarch64
ARCHES_MIPS := mips64el
ARCHES_ALL := $(ARCHES_X86) $(ARCHES_ARM) $(ARCHES_MIPS)

ARCHES_WITHOUT_MIPS := $(ARCHES_X86) $(ARCHES_ARM)

CURL_FLAGS ?= -s

# decided to use curl for downloads d:
#WGET_FLAGS ?= -q
# wget $(WGET_FLAGS) -O $$@ $1

# might be useful
RANDOM_STRING = $(shell hexdump -v -n 16 -e '4 /4  "%08X" 1 "\n"' /dev/urandom)

# Download a fine and check its hash
#
# Defines a target named after the file
#
# arg1: url
# arg2: target file (optional)
define download_file
$(if $1,,$(error "$0: url not speficied"))
$(eval
$(if $2,$2,$(notdir $1)):
	curl $(CURL_FLAGS) -o $$@ $1
	@if [ ! -f $$@.sha256 ]; then \
		echo "Warning: Hash file $$@.sha256 not found!"; \
		echo "Expected hash:"; \
		sha256sum $$@; \
	else \
		sha256sum -c $$@.sha256; \
		if [ $$$$? -ne 0 ]; then \
			echo "SHA256 hash check failed! Removing $$@."; \
			rm -f $$@; \
			exit 1; \
		fi \
	fi
)
endef

# Downloads a tar file and extracts it to src
#
# also adds clean-ark since (for now) this expects to be called when
# downloading main source code
#
# TODO: remove arg3 and detect it instead
#
# arg1: url
# arg2: target file
# arg3: unpacked directory
# arg4: target directory
define download_and_extract_tar
$(if $1,,$(error "$0: url not speficied"))
$(if $2,,$(error "$0: target file not speficied"))
$(if $3,,$(error "$0: unpacked directory not speficied"))
$(if $4,,$(error "$0: target directory not speficied"))
$(call download_file,$1,$2)
$(eval
src: | $2
	tar xf $$|
	mv $3 $4

.PHONY: clean-ark
clean-ark:
	-rm $2
)
endef

# this is here just to ensure that "all" is the default
all:

# default to building for all targets
ifndef TARGETS
TARGETS := $(ARCHES_ALL)
endif

export TARGETS

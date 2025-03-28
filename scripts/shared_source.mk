# Download a file and check its hash
#
# Defines a target named after the file
#
# arg1: url
# arg2: target file (optional)
define download
$(if $1,,$(error "$0: url not speficied"))
$(foreach t,$(if $2,$2,$(notdir $1)),
$(eval
$t:
	$(SCRIPTS_DIR)/download.sh $1 $t
clean/$t:
	-rm $$(patsubst clean/%,%,$$@)
clean-all: clean/$t
)
)
endef

# Extract a tar file and rename it to sth
#
# arg1: tar archive
# arg2: unpacked directory
# arg3: target directory
# arg4: deps (optional)
define extract_tar
$(eval
$3: $1 | $4
	@if [ -d "$$@" ]; then \
		rm -r $$@; \
	fi
	tar xf $$<
	mv $2 $$@
	@touch $$@
clean/$3:
	@if [ -d "$2" ]; then \
		rm -r $2; \
	fi
	-rm -r $3
clean $(foreach d,$4,clean-$d): clean/$3
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
$(call download,$1,$2)
$(call extract_tar,$2,$3,$4,$5)
endef

define p_download_and_extract_tar
$(if $1,,$(error "$0: prefix not speficied"))
$(call download_and_extract_tar,$($1_URL),$($1_FILENAME),$($1_EXTRACTED),$($1_DIR),$($1_DIR_DEPS))
$(eval
unpack: $($1_DIR)
download: $($1_FILENAME)
)
endef

.PHONY: all prepare clean clean-all download
all: prepare
prepare:
clean:
clean-all: clean
download:

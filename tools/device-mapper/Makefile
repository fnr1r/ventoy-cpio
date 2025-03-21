include ../../scripts/here.mk
include $(SCRIPTS_DIR)/shared.mk

SUPPORTED_ARCHES := $(ARCHES_ALL)

include $(SCRIPTS_DIR)/shared_build.mk

NAME := device-mapper
VERSION := 1.02.28

BIN_NAME := dmsetup

SRC_DIR := $(NAME).$(VERSION)
SRC_FILENAME := $(SRC_DIR).tgz
SRC_URL := ftp://sourceware.org/pub/dm/$(SRC_FILENAME)

.PHONY: all build clean
all: build
build: $(SUPPORTED_TARGETS)
clean:
	-rm -r build dist src

$(call download_and_extract_tar,$(SRC_URL),$(SRC_FILENAME),$(SRC_DIR),src)

dist:
	mkdir -p $@

dist/%/$(BIN_NAME): build.sh | src dist
	+MAKEFLAGS="$$MFLAGS" bash build.sh $(patsubst dist/%/$(BIN_NAME),%,$@) $(MAKE)

.PHONY: $(SUPPORTED_ARCHES)
$(foreach arch,$(SUPPORTED_ARCHES), $(eval \
	$(arch): dist/$(arch)/$(BIN_NAME)	\
))

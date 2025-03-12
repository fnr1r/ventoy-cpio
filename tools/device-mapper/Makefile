include ../../scripts/here.mk
include $(SCRIPTS_DIR)/shared.mk

SUPPORTED_ARCHES := $(ARCHES_WITHOUT_MIPS)

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
	-rm -r dist src

$(call download_and_extract_tar,device-mapper,$(SRC_URL),tgz)

dist:
	mkdir -p $@

dist/%/$(BIN_NAME): build.sh | src dist
	bash build.sh $(patsubst dist/%/$(BIN_NAME),%,$@)

.PHONY: $(SUPPORTED_ARCHES)
$(foreach arch,$(SUPPORTED_ARCHES), $(eval \
	$(arch): dist/$(arch)/$(BIN_NAME)	\
))

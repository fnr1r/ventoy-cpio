include ../../scripts/here.mk
include $(SCRIPTS_DIR)/shared.mk

ARCHITECTURES := i386 x86_64 aarch64

NAME := device-mapper
VERSION := 1.02.28

BIN_NAME := dmsetup

SRC_DIR := $(NAME).$(VERSION)
SRC_FILENAME := $(SRC_DIR).tgz
SRC_URL := ftp://sourceware.org/pub/dm/$(SRC_FILENAME)

.PHONY: all build clean
all: build
build: $(ARCHITECTURES)
clean:
	-rm -r dist src

$(call download_and_extract_tar,device-mapper,$(SRC_URL),tgz)

dist:
	mkdir -p $@

dist/%/$(BIN_NAME): build.sh | src dist
	bash build.sh $(patsubst dist/%/$(BIN_NAME),%,$@)

.PHONY: $(ARCHITECTURES)
$(foreach arch,$(ARCHITECTURES), $(eval \
	$(arch): dist/$(arch)/$(BIN_NAME)	\
))

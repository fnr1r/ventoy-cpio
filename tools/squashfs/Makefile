include ../../scripts/here.mk
include $(SCRIPTS_DIR)/shared.mk

SUPPORTED_ARCHES := x86_64

include $(SCRIPTS_DIR)/shared_build.mk

NAME := squashfs
VERSION := 4.4

SRC_DIR := $(NAME)$(VERSION)
SRC_FILENAME := $(SRC_DIR).tar.gz
SRC_URL := https://netix.dl.sourceforge.net/project/squashfs/squashfs/squashfs4.4/$(SRC_FILENAME)

.PHONY: all build clean
all: build
build: $(SUPPORTED_TARGETS)
clean:
	-rm -r dist src

$(call download_and_extract_tar,$(SRC_URL),$(SRC_FILENAME),$(SRC_DIR),src)

dist:
	mkdir -p $@

dist/%/$(BIN_NAME): build.sh | src dist
	+bash build.sh $(patsubst dist/%/$(BIN_NAME),%,$@) $(MAKE)

.PHONY: $(SUPPORTED_ARCHES)
$(foreach arch,$(SUPPORTED_ARCHES), $(eval \
	$(arch): dist/$(arch)/$(BIN_NAME)	\
))

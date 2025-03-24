include ../../scripts/here.mk
include $(SCRIPTS_DIR)/shared.mk

SUPPORTED_ARCHES := $(ARCHES_WITHOUT_I386)

include $(SCRIPTS_DIR)/shared_build.mk

NAME := fuse
VERSION := 2.9.9

BIN_NAME := vtoy_$(NAME)_iso

SRC_DIR := $(NAME)-$(VERSION)
SRC_FILENAME := $(SRC_DIR).tar.gz
SRC_URL := https://github.com/libfuse/lib$(NAME)/releases/download/$(SRC_DIR)/$(SRC_FILENAME)

.PHONY: all build clean
all: build
build: $(SUPPORTED_TARGETS)
clean:
	-rm -r build dist src/libfuse

$(call download_and_extract_tar,$(SRC_URL),$(SRC_FILENAME),$(SRC_DIR),src/libfuse)

dist/%/$(BIN_NAME): build.sh | src/libfuse
	+bash build.sh $(patsubst dist/%/$(BIN_NAME),%,$@) $(MAKE)

.PHONY: $(SUPPORTED_ARCHES)
$(foreach arch,$(SUPPORTED_ARCHES), $(eval \
	$(arch): dist/$(arch)/$(BIN_NAME)	\
))

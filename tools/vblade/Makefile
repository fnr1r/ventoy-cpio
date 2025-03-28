include ../../scripts/here.mk
include $(SCRIPTS_DIR)/shared.mk

SUPPORTED_ARCHES := $(ARCHES_ALL)

include $(SCRIPTS_DIR)/shared_build.mk

NAME := vblade
VERSION := 24

BIN_NAME := $(NAME)

SRC_DIR := $(NAME)-$(VERSION)
SRC_FILENAME := $(SRC_DIR).tar.gz
SRC_URL := https://github.com/OpenAoE/$(NAME)/archive/refs/tags/$(SRC_FILENAME)

.PHONY: all build clean
all: build
build: $(SUPPORTED_TARGETS)
clean:
	-rm -r build dist src

$(call download_and_extract_tar,$(SRC_URL),$(SRC_FILENAME),$(NAME)-$(SRC_DIR),src)

dist/%/$(BIN_NAME): build.sh | src
	@mkdir -p $(dir $@)
	+bash build.sh $(patsubst dist/%/$(BIN_NAME),%,$@) $(MAKE)

.PHONY: $(SUPPORTED_ARCHES)
$(foreach arch,$(SUPPORTED_ARCHES), $(eval \
	$(arch): dist/$(arch)/$(BIN_NAME)	\
))

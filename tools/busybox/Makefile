include ../../scripts/here.mk
include $(SCRIPTS_DIR)/shared.mk

ARCHITECTURES := i386 x86_64 aarch64 mips64el

NAME := busybox
VERSION := 1.32.0

BIN_NAMES := ash busybox hexdump xzcat

SRC_DIR := $(NAME)-$(VERSION)
SRC_FILENAME := $(SRC_DIR).tar.bz2
SRC_URL := https://busybox.net/downloads/$(SRC_FILENAME)

CONFIGS := $(patsubst configs/%.config,dist/%,$(wildcard configs/*.config))

.PHONY: all build clean
all: build
build: $(ARCHITECTURES)
clean:
	-rm -r dist src

$(call download_and_extract_tar,busybox,$(SRC_URL),tar.bz2)

dist:
	mkdir -p $@

dist/%: | src dist
	bash build.sh $(patsubst dist/%,%,$@) $(MAKE)

.PHONY: $(ARCHITECTURES)
$(foreach arch,$(ARCHITECTURES), $(eval \
	$(arch): $(foreach bin,$(BIN_NAMES), dist/$(arch)_$(bin) )	\
))

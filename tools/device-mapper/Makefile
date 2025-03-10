HERE := $(patsubst %/,%,$(dir $(realpath $(lastword $(MAKEFILE_LIST)))))

ARCHITECTURES := i386 x86_64 aarch64

NAME := device-mapper
VERSION := 1.02.28

BIN_NAME := dmsetup

SRC_DIR := $(NAME).$(VERSION)
SRC_FILENAME := $(SRC_DIR).tgz
SRC_URL := ftp://sourceware.org/pub/dm/$(SRC_FILENAME)

.PHONY: all build
all: build
build: $(ARCHITECTURES)

clean:
	-rm -r dist src

clean-ark:
	-rm $(SRC_FILENAME)

$(SRC_FILENAME):
	wget -q $(SRC_URL)
	sha256sum -c $@.sha256 || rm $@

src: | $(SRC_FILENAME)
	tar xzf $(SRC_FILENAME)
	mv $(SRC_DIR) src

dist:
	mkdir -p $@

dist/%/$(BIN_NAME): build.sh | src dist
	bash build.sh $(patsubst dist/%/$(BIN_NAME),%,$@)

.PHONY: $(ARCHITECTURES)
$(foreach arch,$(ARCHITECTURES), $(eval \
	$(arch): dist/$(arch)/$(BIN_NAME)	\
))

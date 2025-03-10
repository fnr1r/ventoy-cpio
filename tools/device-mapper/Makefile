HERE := $(patsubst %/,%,$(dir $(realpath $(lastword $(MAKEFILE_LIST)))))

NAME := device-mapper
VERSION := 1.02.28

BIN_NAME := dmsetup

SRC_DIR := $(NAME).$(VERSION)
SRC_FILENAME := $(SRC_DIR).tgz
SRC_URL := ftp://sourceware.org/pub/dm/$(SRC_FILENAME)

.PHONY: all
all: i386 x86_64 aarch64

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

.PHONY: i386 x86_64 aarch64
i386: dist/i386/$(BIN_NAME)
x86_64: dist/x86_64/$(BIN_NAME)
aarch64: dist/aarch64/$(BIN_NAME)

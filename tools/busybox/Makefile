HERE := $(patsubst %/,%,$(dir $(realpath $(lastword $(MAKEFILE_LIST)))))

NAME := busybox
VERSION := 1.32.0

SRC_DIR := $(NAME)-$(VERSION)
SRC_FILENAME := $(SRC_DIR).tar.bz2
SRC_URL := https://busybox.net/downloads/$(SRC_FILENAME)

CONFIGS := $(patsubst configs/%.config,dist/%,$(wildcard configs/*.config))

.PHONY: all build
all: build
build: $(CONFIGS)

clean:
	rm -r dist src

clean-ark:
	rm $(SRC_FILENAME)

$(SRC_FILENAME):
	wget -q $(SRC_URL)
	sha256sum -c $@.sha256

src: $(SRC_FILENAME)
	tar xvf $(SRC_FILENAME)
	mv $(SRC_DIR) src

dist:
	mkdir -p $@

dist/%: configs/%.config | src dist
	bash build.sh $(patsubst dist/%,%,$@)

#ARCHITECTURES := i386 x86_64 aarch64

#.PHONY: $(ARCHITECTURES)
#i386: dist/i386/ash
#x86_64: dist/x86_64/ash
#aarch64: dist/aarch64/ash

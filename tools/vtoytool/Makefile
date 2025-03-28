include ../../scripts/here.mk
include $(SCRIPTS_DIR)/shared.mk

SUPPORTED_ARCHES := $(ARCHES_ALL)

include $(SCRIPTS_DIR)/shared_build.mk

BIN_NAME := vtoytool

.PHONY: all build clean
all: build
build: $(SUPPORTED_TARGETS)
clean:
	-rm -r build dist

dist/%/$(BIN_NAME): $(wildcard src/*)
	@mkdir -p $(dir $@)
	+$(MAKE) -C src ARCH=$(patsubst dist/%/$(BIN_NAME),%,$@)

.PHONY: $(SUPPORTED_ARCHES)
$(foreach arch,$(SUPPORTED_ARCHES), $(eval \
	$(arch): dist/$(arch)/$(BIN_NAME)	\
))

include scripts/here.mk
include $(SCRIPTS_DIR)/shared.mk

BUILD_DIR ?= build
DIST_DIR ?= dist

.PHONY: all build clean clean-src clean-all download prepare
all: build
build: arch base
clean clean-src clean-all download prepare:
	+$(MAKE) -f source.mk $@

.PHONY: tools
tools:
	+$(MAKE) -C $@

.PHONY: base
base: $(DIST_DIR)/ventoy.cpio

.PHONY: $(DIST_DIR)/ventoy.cpio
$(DIST_DIR)/ventoy.cpio:
	+$(MAKE) -f cpio.base.mk

.PHONY: arch
arch: tools arch-ramdisks

$(BUILD_DIR)/tool_%.cpio: | tools
	bash scripts/build_arch_tool.sh $@ $(patsubst $(BUILD_DIR)/tool_%.cpio,%,$@)

$(DIST_DIR)/ventoy_%.cpio: $(BUILD_DIR)/tool_%.cpio # $(wildcard arch/$(patsubst build/ventoy_%.cpio,%, $@)/*)
	bash scripts/build_arch.sh $@ $(patsubst $(DIST_DIR)/ventoy_%.cpio,%,$@)

.PHONY: arch-ramdisks
arch-ramdisks: $(foreach a,$(RD_ARCHES_ALL),$(DIST_DIR)/ventoy_$a.cpio)

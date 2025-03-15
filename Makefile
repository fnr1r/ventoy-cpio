include scripts/here.mk
include $(SCRIPTS_DIR)/shared.mk

BUILD_DIR ?= build
DIST_DIR ?= dist

.PHONY: all build clean
all: build
build: arch base
clean:
	-rm -r dist build

.PHONY: arch tools tools-bin
arch: tools tools-bin

.PHONY: base
base: $(DIST_DIR)/ventoy.cpio $(DIST_DIR)/ventoy_x86.cpio

include $(SCRIPTS_DIR)/submake.mk

$(call add_submake_hack,tools,tools,tools)
$(call add_submake_hack,tools-bin,tools_bin,tools-bin)

$(DIST_DIR)/ventoy.cpio:
	+$(MAKE) -f cpio.base.mk

$(BUILD_DIR)/tool_%.cpio: | tools
	bash scripts/build_arch_tool.sh $@ $(patsubst $(BUILD_DIR)/tool_%.cpio,%,$@)

$(DIST_DIR)/ventoy_%.cpio: $(BUILD_DIR)/tool_%.cpio # $(wildcard arch/$(patsubst build/ventoy_%.cpio,%, $@)/*)
	bash scripts/build_arch.sh $@ $(patsubst $(DIST_DIR)/ventoy_%.cpio,%,$@)

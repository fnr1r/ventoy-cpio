include scripts/here.mk
include $(SCRIPTS_DIR)/shared.mk

BUILD_DIR ?= build
DIST_DIR ?= dist

.PHONY: all build arch tools base clean
all: build
build: arch base
clean:
	-rm -r dist build

arch: tools
tools:

base: $(DIST_DIR)/ventoy.cpio $(DIST_DIR)/ventoy_x86_64.cpio

include $(SCRIPTS_DIR)/submake.mk

TOOLS := busybox device-mapper xz-embedded zstd

$(foreach tool,$(TOOLS),\
	$(call add_submake_hack,$(tool),tools/$(tool),tools_busybox,tools)\
)

$(DIST_DIR)/ventoy.cpio:
	+$(MAKE) -f cpio.base.mk

$(BUILD_DIR)/tool_%.cpio:
	bash scripts/build_arch_tool.sh $@ $(patsubst $(BUILD_DIR)/tool_%.cpio,%,$@)

$(DIST_DIR)/ventoy_%.cpio: $(BUILD_DIR)/tool_%.cpio # $(wildcard arch/$(patsubst build/ventoy_%.cpio,%, $@)/*)
	bash scripts/build_arch.sh $@ $(patsubst $(DIST_DIR)/ventoy_%.cpio,%,$@)

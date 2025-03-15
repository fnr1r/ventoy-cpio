include scripts/here.mk
include $(SCRIPTS_DIR)/shared.mk

DIST_DIR := dist

.PHONY: all build arch tools base clean
all: build
build: arch base
clean:
	-rm -r dist build

arch: tools
tools:

base: $(DIST_DIR)/ventoy.cpio

include $(SCRIPTS_DIR)/submake.mk

TOOLS := busybox device-mapper xz-embedded zstd

$(foreach tool,$(TOOLS),\
	$(call add_submake_hack,$(tool),tools/$(tool),tools_busybox,tools)\
)

$(DIST_DIR)/ventoy.cpio:
	+$(MAKE) -f cpio.base.mk

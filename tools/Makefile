include ../scripts/here.mk
include $(SCRIPTS_DIR)/shared.mk

.PHONY: all build clean tools
all: build
build: tools
clean:
tools: 

TOOLS := busybox device-mapper squashfs xz-embedded zstd

include $(SCRIPTS_DIR)/submake.mk

$(foreach tool,$(TOOLS),\
	$(call add_submake_hack,$(tool),$(tool),tools_$(tool),tools)\
)

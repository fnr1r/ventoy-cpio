include ../scripts/here.mk
include $(SCRIPTS_DIR)/shared.mk

.PHONY: all build clean tools
all: build
build: tools
clean:
tools: 

TOOLS := busybox device-mapper lz4 squashfs vblade vtchmod vtoy_fuse_iso vtoytool xz-embedded zstd

include $(SCRIPTS_DIR)/submake.mk

$(foreach tool,$(TOOLS),\
	$(call add_submake_hack,$(tool),$(tool),tools_$(tool),tools)\
)

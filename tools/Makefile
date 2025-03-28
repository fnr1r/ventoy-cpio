include ../scripts/here.mk
include $(SCRIPTS_DIR)/shared.mk

TOOLS := busybox device-mapper lz4 squashfs vblade vtchmod vtoy_fuse_iso vtoytool xz-embedded zstd

.PHONY: all build clean tools
all: build
build: $(TOOLS)
clean: $(foreach t,$(TOOLS),clean/$t)
clean/%:
	+$(MAKE) -C $(call reverse,$(subst /, ,$@))

.PHONY: $(TOOLS)
$(TOOLS):
	+$(MAKE) -C $@

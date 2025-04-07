include ../scripts/here.mk
include $(SCRIPTS_DIR)/shared.mk

TOOLS := busybox device-mapper lunzip lz4 squashfs vblade vtchmod vtoy_fuse_iso vtoytool xz-embedded zstd

.PHONY: all build clean clean-src clean-all download prepare
all: build
build: $(TOOLS)
clean: $(foreach t,$(TOOLS),clean/$t)
clean-src: $(foreach t,$(TOOLS),clean-src/$t)
clean-all: $(foreach t,$(TOOLS),clean-all/$t)
download: $(foreach t,$(TOOLS),download/$t)
prepare: $(foreach t,$(TOOLS),prepare/$t)
clean/% clean-src/% clean-all/% download/% prepare/%:
	$(call slash_passtrough,$@)

.PHONY: $(TOOLS)
$(TOOLS):
	+$(MAKE) -C $@

include ../scripts/here.mk
include $(SCRIPTS_DIR)/shared.mk

.PHONY: all build clean clean-src clean-all
all: build
build:
clean:
clean-src:
clean-all:

TOOLS := busybox device-mapper lunzip lz4 squashfs vblade vtchmod vtoy_fuse_iso vtoytool xz-embedded zstd

build: $(TOOLS)
.PHONY: $(TOOLS)
$(TOOLS):
	+$(MAKE) -C $@

clean: $(foreach t,$(TOOLS),clean-$t)
$(foreach t,$(TOOLS),clean-$t):
	+$(MAKE) -C $(patsubst clean-%,%,$@) clean

clean-src: $(foreach t,$(TOOLS),clean-src-$t)
$(foreach t,$(TOOLS),clean-src-$t):
	+$(MAKE) -C $(patsubst clean-src-%,%,$@) clean-src

clean-all: $(foreach t,$(TOOLS),clean-all-$t)
$(foreach t,$(TOOLS),clean-all-$t):
	+$(MAKE) -C $(patsubst clean-all-%,%,$@) clean-all

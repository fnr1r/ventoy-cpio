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

BUSYBOX_ARCHIVES := $(firstword $(wildcard busybox/busybox-*.tar.bz2))
BUSYBOX_SOURCE = $(shell find busybox/src)

busybox/src: $(BUSYBOX_ARCHIVES)
	$(error make -C busybox -f source.mk)

BUSYBOX_SELF_CONFIG := busybox/configs/01-defconfig-static.config

BUSYBOX_TARGETS = $(BUSYBOX_ARCHIVES) $(BUSYBOX_SOURCE)
BUSYBOX_SELF_TARGETS = $(BUSYBOX_TARGETS) $(BUSYBOX_SELF_CONFIG)

busybox/dist/%/busybox: $(BUSYBOX_SELF_TARGETS)
	$(error make -C busybox -f build.mk TARGET=$(patsubst busybox/dist/%/busybox,%,$@))




VTCHMOD_SOURCE = vtchmod/Makefile $(wildcard vtchmod/src/*)

vtchmod/dist/%/vtchmod: vtchmod/src
	$(error make -C vtchmod -f build.mk TARGET=$(patsubst vtchmod/dist/%/vtchmod,%,$@))



VTOY_FUSE_ISO_ARCHIVES := $(firstword $(wildcard vtoy_fuse_iso/fuse-*.tar.gz))
VTOY_FUSE_ISO_SOURCE = $(wildcard vtoy_fuse_iso/src/*.*) $(shell find vtoy_fuse_iso/src/libfuse)

vtoy_fuse_iso/src: $(VTOY_FUSE_ISO_ARCHIVES)

vtoy_fuse_iso/dist/%/vtoy_fuse_iso: vtoy_fuse_iso/src
	$(error make -C vtoy_fuse_iso -f build.mk TARGET=$(patsubst vtoy_fuse_iso/dist/%/vtoy_fuse_iso,%,$@))

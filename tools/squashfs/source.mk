include ../../scripts/here.mk
include $(SCRIPTS_DIR)/shared_source_tools.mk
include info.mk

prepare: download unpack patch

ARCHIVES := SRC LZ4 LZO XZ ZLIB ZSTD

$(foreach a,$(ARCHIVES),$(call p_download_and_extract_tar,$a))

patch: $(SRC_DIR)/squashfs-tools/.patched

PATCH_DIR := patches

# patches from https://github.com/fnr1r/squashfs-tools branch ventoy_patched
PATCHES := $(wildcard $(PATCH_DIR)/*)

$(SRC_DIR)/squashfs-tools/.patched: $(PATCHES) | src
	$(info patching with $^)
	@cd $(dir $@) && for patch in $^; do \
		patch -i "$(HERE)/$$patch" -p 2; \
	done
	@touch $@

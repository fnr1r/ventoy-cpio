include ../../scripts/here.mk
include $(SCRIPTS_DIR)/shared.mk
include $(SCRIPTS_DIR)/shared_source.mk
include info.mk

prepare: unpack download

ARCHIVES := SRC LZ4 LZO XZ ZLIB ZSTD

$(foreach a,$(ARCHIVES),$(call p_download_and_extract_tar,$a))

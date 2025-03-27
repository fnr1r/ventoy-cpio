include ../../scripts/here.mk
include $(SCRIPTS_DIR)/shared.mk
include meta.mk

.PHONY: all download clean clean-all
all: download
download: src src/lz4 src/lzo src/xz src/zlib src/zstd
clean:
clean-all: clean

$(call p_download_and_extract_tar,SRC)
$(call p_download_and_extract_tar,LZ4)
$(call p_download_and_extract_tar,LZO)
$(call p_download_and_extract_tar,XZ)
$(call p_download_and_extract_tar,ZLIB)
$(call p_download_and_extract_tar,ZSTD)

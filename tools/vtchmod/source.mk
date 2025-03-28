include ../../scripts/here.mk
include $(SCRIPTS_DIR)/shared.mk
include meta.mk

.PHONY: all download clean clean-all
all: download
download:
clean:
clean-all: clean

#$(call p_download_and_extract_tar,SRC)

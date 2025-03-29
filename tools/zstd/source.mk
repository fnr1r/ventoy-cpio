include ../../scripts/here.mk
include $(SCRIPTS_DIR)/shared.mk
include $(SCRIPTS_DIR)/shared_source.mk
include info.mk

prepare: download unpack

$(call p_download_and_extract_tar,SRC)

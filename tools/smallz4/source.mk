include ../../scripts/here.mk
include $(SCRIPTS_DIR)/shared_source_tools.mk
include info.mk

prepare: download

$(call download,$(SRC_URL),$(SRC_DIR)/$(SRC_FILENAME))
download: $(SRC_DIR)/$(SRC_FILENAME)

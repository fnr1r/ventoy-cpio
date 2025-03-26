include scripts/here.mk
include $(SCRIPTS_DIR)/shared.mk

BUILD_DIR := build
DIST_DIR ?= dist
SRC_DIR := base
WORK_DIR := $(BUILD_DIR)/ventoy

BASE_FILES := $(SRC_DIR)/sbin/init $(wildcard $(SRC_DIR)/ventoy/init*)
BASE_CPIO_NAMES := hook loop
BASE_SCRIPT_NAMES := ventoy_chain ventoy_loop
BASE_SYMLINKS := init linuxrc

BASE_CPIOS := $(foreach i,$(BASE_CPIO_NAMES),$(WORK_DIR)/ventoy/$i.cpio.xz)
BASE_SCRIPTS := $(foreach i,$(BASE_SCRIPT_NAMES),$(WORK_DIR)/ventoy/$i.sh.xz)

TARGETS_COPIED := $(patsubst $(SRC_DIR)/%,$(WORK_DIR)/%,$(BASE_FILES))
TARGETS_COMPRESSED := $(BASE_CPIOS) $(BASE_SCRIPTS)
TARGETS_SYMLINKS := $(foreach i,$(BASE_SYMLINKS),$(WORK_DIR)/$i)
TARGETS := $(TARGETS_COPIED) $(TARGETS_COMPRESSED) $(TARGETS_SYMLINKS)

$(DIST_DIR)/ventoy.cpio: $(TARGETS)
	@mkdir -p $(dir $@)
	cd $(WORK_DIR) && \
		find . \
		| cpio -o -H newc --owner=root:root \
		> $(HERE)/$@

$(TARGETS_SYMLINKS):
	@mkdir -p $(dir $@)
	ln -s sbin/init $@

$(WORK_DIR)/%.sh.xz: $(SRC_DIR)/%.sh
	@mkdir -p $(dir $@)
	cat $< | xz $(XZ_FLAGS) > $@

$(WORK_DIR)/%.cpio.xz: $(shell find $(SRC_DIR)/ventoy/$%)
	@mkdir -p $(dir $@)
	cd $< && \
		find $(patsubst $(WORK_DIR)/ventoy/%.cpio.xz,%,$@) \
		| cpio -o -H newc --owner=root:root \
		| xz $(XZ_FLAGS) > $(HERE)/$@

$(WORK_DIR)/%: $(SRC_DIR)/%
	@mkdir -p $(dir $@)
	cp -a $< $@

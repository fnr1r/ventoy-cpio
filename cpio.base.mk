include scripts/here.mk
include $(SCRIPTS_DIR)/shared.mk

BUILD_DIR := build
DIST_DIR ?= dist
SRC_DIR := base

BASE_CPIOS := build/hook.cpio.xz build/loop.cpio.xz
BASE_SCRIPTS := build/ventoy_chain.sh.xz build/ventoy_loop.sh.xz
BASE_FILES := $(SRC_DIR)/sbin/init $(wildcard $(SRC_DIR)/ventoy/init*)

$(DIST_DIR)/ventoy.cpio: $(BASE_CPIOS) $(BASE_SCRIPTS) $(BASE_FILES)
	bash scripts/build_base.sh $@

build/%.sh.xz: base/ventoy/%.sh
	@mkdir -p $(dir $@)
	cat $< | xz $(XZ_FLAGS) > $@

build/%.cpio.xz: $(wildcard $(SRC_DIR)/ventoy/%/*)
	@mkdir -p $(dir $@)
	cd base/ventoy && \
		find ./$(patsubst build/%.cpio.xz,%,$@) \
		| cpio -o -H newc --owner=root:root \
		| xz $(XZ_FLAGS) > $(HERE)/$@

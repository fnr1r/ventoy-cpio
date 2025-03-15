include scripts/here.mk
include $(SCRIPTS_DIR)/shared.mk

DIST_DIR ?= dist

$(DIST_DIR)/ventoy.cpio: build/hook.cpio.xz build/loop.cpio.xz build/ventoy_chain.sh.xz build/ventoy_loop.sh.xz $(wildcard base/ventoy/init*)
	bash scripts/build_base.sh $@

build/%.sh.xz: base/ventoy/%.sh
	cat $< | xz > $@

build/%.cpio.xz: $(wildcard base/ventoy/%/*) | build
	cd base/ventoy && find ./$(patsubst build/%.cpio.xz,%,$@) | cpio -o -H newc --owner=root:root | xz > $(HERE)/$@

build:
	mkdir -p $@

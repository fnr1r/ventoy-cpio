include scripts/here.mk
include $(SCRIPTS_DIR)/shared.mk

ifneq ($(REPRODUCIBLE),)
CPIO_REPRO := $(REPRODUCIBLE)
endif

CPIO_FLAGS := -H newc --owner=root:root

BUILD_DIR := build
DIST_DIR := dist
SRC_DIR := base
WORK_DIR := $(BUILD_DIR)/ventoy
WORK_DIR_BASE := $(WORK_DIR)/base

BASE_FILES := $(SRC_DIR)/sbin/init $(wildcard $(SRC_DIR)/ventoy/init*)
BASE_CPIO_NAMES := hook loop
BASE_SCRIPT_NAMES := ventoy_chain ventoy_loop
BASE_SYMLINKS := init linuxrc

BASE_CPIOS := $(foreach i,$(BASE_CPIO_NAMES),$(WORK_DIR_BASE)/ventoy/$i.cpio.xz)
BASE_SCRIPTS := $(foreach i,$(BASE_SCRIPT_NAMES),$(WORK_DIR_BASE)/ventoy/$i.sh.xz)

TARGETS_COPIED := $(patsubst $(SRC_DIR)/%,$(WORK_DIR_BASE)/%,$(BASE_FILES))
TARGETS_COMPRESSED := $(BASE_CPIOS) $(BASE_SCRIPTS)
TARGETS_SYMLINKS := $(addprefix $(WORK_DIR_BASE)/,$(BASE_SYMLINKS))
BASE_TARGETS := $(TARGETS_COPIED) $(TARGETS_COMPRESSED) $(TARGETS_SYMLINKS)

$(DIST_DIR)/ventoy.cpio: $(BASE_TARGETS)
	@mkdir -p $(dir $@)
	$(if $(CPIO_REPRO),find $(WORK_DIR_BASE) -exec env TZ="UTC" touch --date="1970-01-01" {} \;,)
	cd $(WORK_DIR_BASE) && \
		find . \
		| cpio -o  \
		> $(HERE)/$@

$(WORK_DIR_BASE)/ventoy/%.xz: $(WORK_DIR)/%.xz
	@mkdir -p $(dir $@)
	cp -a $< $@

$(TARGETS_SYMLINKS):
	@mkdir -p $(dir $@)
	ln -sf sbin/init $@

$(WORK_DIR)/%.sh.xz: $(SRC_DIR)/ventoy/%.sh
	@mkdir -p $(dir $@)
	cat $< | xz $(XZ_FLAGS) > $@

define cpiodef
$(eval
$(WORK_DIR)/$1.cpio.xz: $$(shell find $(SRC_DIR)/ventoy/$1)
	mkdir -p $(WORK_DIR)/$1
	cp -a $(SRC_DIR)/ventoy/$1/. $(WORK_DIR)/$1
	$(if $(CPIO_REPRO),find $(WORK_DIR)/$1 -exec env TZ="UTC" touch --date="1970-01-01" {} \;,)
	cd $(WORK_DIR) && \
		find $1 \
		| cpio -o $(CPIO_FLAGS) \
		| xz $(XZ_FLAGS) > $(HERE)/$$@
)
endef

$(foreach c,$(BASE_CPIO_NAMES),$(call cpiodef,$c))

$(WORK_DIR)/base/%: $(SRC_DIR)/%
	@mkdir -p $(dir $@)
	cp -a $< $@

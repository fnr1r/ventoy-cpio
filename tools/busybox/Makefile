include ../../scripts/here.mk
include $(SCRIPTS_DIR)/shared.mk
include info.mk

SUPPORTED_ARCHES := $(ARCHES_ALL)

include $(SCRIPTS_DIR)/shared_main.mk

src:
	+$(MAKE) -f source.mk
dist/%: | src
	@mkdir -p $(dir $@)
	+bash build.sh $(patsubst dist/%,%,$@) $(MAKE)

.PHONY: $(SUPPORTED_ARCHES)
$(foreach arch,$(SUPPORTED_ARCHES), $(eval \
	$(arch): $(foreach bin,$(BIN_NAMES), dist/$(arch)_$(bin) )	\
))

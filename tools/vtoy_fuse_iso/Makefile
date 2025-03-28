include ../../scripts/here.mk
include $(SCRIPTS_DIR)/shared.mk
include info.mk

SUPPORTED_ARCHES := $(ARCHES_WITHOUT_I386)

include $(SCRIPTS_DIR)/shared_main.mk

.PHONY: src
src: src/libfuse
src/libfuse:
	+$(MAKE) -f source.mk
dist/%/$(BIN_NAME): | src/libfuse
	@mkdir -p $(dir $@)
	+bash build.sh $(patsubst dist/%/$(BIN_NAME),%,$@) $(MAKE)

.PHONY: $(SUPPORTED_ARCHES)
$(foreach arch,$(SUPPORTED_ARCHES), $(eval \
	$(arch): dist/$(arch)/$(BIN_NAME)	\
))

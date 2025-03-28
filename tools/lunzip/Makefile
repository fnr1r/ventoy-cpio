include ../../scripts/here.mk
include $(SCRIPTS_DIR)/shared.mk
include info.mk

SUPPORTED_ARCHES := $(ARCHES_ALL)

include $(SCRIPTS_DIR)/shared_main.mk

src:
	+$(MAKE) -f source.mk
dist/%/$(NAME): | src
	@mkdir -p $(dir $@)
	+bash build.sh $(patsubst dist/%/$(NAME),%,$@) $(MAKE)

.PHONY: $(SUPPORTED_ARCHES)
$(foreach arch,$(SUPPORTED_ARCHES), $(eval \
	$(arch): dist/$(arch)/$(NAME)	\
))

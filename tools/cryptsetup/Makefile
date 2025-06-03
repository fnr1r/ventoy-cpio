include ../../scripts/here.mk
include $(SCRIPTS_DIR)/shared_main.mk
include info.mk

# i386: build broken due to missing libuuid-dev:i386

SUPPORTED_ARCHES := x86_64

include $(SCRIPTS_DIR)/shared_main_tools.mk

.PHONY: src
src:
	+$(MAKE) -f source.mk
dist/%/$(BIN_NAME): src
	+$(MAKE) -f build.mk TARGET=$(patsubst dist/%/$(BIN_NAME),%,$@)

.PHONY: $(SUPPORTED_ARCHES)
$(foreach a,$(SUPPORTED_ARCHES), \
	$(eval dist/$a/$(BIN_NAME):) $(eval $a: dist/$a/$(BIN_NAME)) \
)

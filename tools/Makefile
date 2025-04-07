include ../scripts/here.mk
include $(SCRIPTS_DIR)/shared_main.mk
include info.mk

.PHONY: all build clean clean-src clean-all download prepare
all: build
build: $(TOOLS)

.PHONY: $(TOOLS)
$(TOOLS):
	+$(MAKE) -C $@

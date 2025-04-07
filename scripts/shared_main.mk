ifndef SCRIPTS_DIR
$(error SCRIPTS_DIR not set)
endif
include $(SCRIPTS_DIR)/shared.mk

.PHONY: all build clean clean-src clean-all download prepare
all: build
build: $(SUPPORTED_TARGETS)
clean clean-src clean-all download prepare:
	+$(MAKE) -f source.mk $@

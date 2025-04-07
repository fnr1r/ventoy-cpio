ifndef SCRIPTS_DIR
$(error SCRIPTS_DIR not set)
endif
include $(SCRIPTS_DIR)/shared.mk

.PHONY: all
all:

.PHONY: clean clean-src clean-all download prepare
clean clean-src clean-all download prepare:
	+$(MAKE) -f source.mk $@

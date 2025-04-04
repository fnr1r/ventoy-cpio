ifndef SCRIPTS_DIR
$(error SCRIPTS_DIR not set)
endif
include $(SCRIPTS_DIR)/shared.mk

.PHONY: all build clean clean-src clean-all download prepare
all: build
build:
clean:
clean-src:
	+$(MAKE) -f source.mk clean
clean-all:
	+$(MAKE) -f source.mk $@
download prepare:
	+$(MAKE) -f source.mk $@

ifndef TARGETS
$(error "TARGETS not set")
endif

ifndef SUPPORTED_ARCHES
$(error "SUPPORTED_ARCHES not set by the importer")
endif

SUPPORTED_TARGETS := $(strip $(foreach target,$(TARGETS),$(filter $(SUPPORTED_ARCHES),$(target))))

.PHONY: all build clean clean-src clean-all download prepare
all: build
build: $(SUPPORTED_TARGETS)
clean:
	-rm -r build dist
clean-src: clean
	+$(MAKE) -f source.mk clean
clean-all: clean
	+$(MAKE) -f source.mk $@
download prepare:
	+$(MAKE) -f source.mk $@

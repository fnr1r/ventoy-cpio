ifndef TARGETS
$(error "TARGETS not set")
endif

ifndef SUPPORTED_ARCHES
$(error "SUPPORTED_ARCHES not set by the importer")
endif

SUPPORTED_TARGETS := $(strip $(foreach target,$(TARGETS),$(filter $(SUPPORTED_ARCHES),$(target))))

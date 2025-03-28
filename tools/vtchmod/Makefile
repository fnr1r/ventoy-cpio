include ../../scripts/here.mk
include $(SCRIPTS_DIR)/shared.mk
include meta.mk

SUPPORTED_ARCHES := $(ARCHES_ALL)

.PHONY: all build clean clean-src clean-all
all: build
build: $(SUPPORTED_ARCHES)
clean:
	-rm -r dist build
clean-src: clean
	+$(MAKE) -f source.mk clean
clean-all: clean
	+$(MAKE) -f source.mk clean-all

.PHONY: src
src:
	+$(MAKE) -f source.mk
dist/%/$(BIN_NAME): src
	+$(MAKE) -f build.mk TARGET=$(patsubst dist/%/$(BIN_NAME),%,$@)

.PHONY: $(SUPPORTED_ARCHES)
$(foreach a,$(SUPPORTED_ARCHES), \
	$(eval dist/$a/$(BIN_NAME):) $(eval $a: dist/$a/$(BIN_NAME)) \
)

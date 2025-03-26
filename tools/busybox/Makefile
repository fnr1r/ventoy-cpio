include ../../scripts/here.mk
include $(SCRIPTS_DIR)/shared.mk
include meta.mk

SUPPORTED_ARCHES := $(ARCHES_ALL)

.PHONY: all build clean
all: build
build:
clean:
	-rm -r build dist src

.PHONY: src dist/%
src:
	+$(MAKE) -f source.mk
dist/%: src
	+$(MAKE) -f build.mk TARGET=$(patsubst dist/%,%,$@)

# for autocompletion
$(foreach a,$(SUPPORTED_ARCHES), $(foreach b,$(BIN_NAMES), \
	$(eval dist/$a-$b:) $(eval build: dist/$a-$b) \
))

$(foreach a,$(SUPPORTED_ARCHES), $(eval \
	$a: $(foreach b,$(BIN_NAMES), dist/$a-$b ) \
))

$(foreach b,$(BIN_NAMES), $(eval \
	$b: $(foreach a,$(SUPPORTED_ARCHES), dist/$a-$b )\
))

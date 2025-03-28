include ../../scripts/here.mk
include $(SCRIPTS_DIR)/shared.mk
include info.mk

SUPPORTED_ARCHES := $(ARCHES_ALL)

include $(SCRIPTS_DIR)/shared_main.mk

.PHONY: src
src:
	+$(MAKE) -f source.mk
dist/%: src
	+$(MAKE) -f build.mk TARGET=$(patsubst dist/%,%,$@)

# for autocompletion
$(foreach a,$(SUPPORTED_ARCHES), $(foreach b,$(BIN_NAMES), \
	$(eval dist/$a-$b dist/$a/$b:) \
	$(eval $a-$b: dist/$a-$b) \
	$(eval build: dist/$a-$b) \
))

$(foreach a,$(SUPPORTED_ARCHES), $(eval \
	$a: $(foreach b,$(BIN_NAMES), $a-$b ) \
))

$(foreach b,$(BIN_NAMES), $(eval \
	$b: $(foreach a,$(SUPPORTED_ARCHES), $a-$b )\
))

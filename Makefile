include scripts/here.mk
include $(SCRIPTS_DIR)/shared.mk

.PHONY: all build
all: build
build: submakes

include $(SCRIPTS_DIR)/submake.mk

TOOLS := busybox device-mapper

$(foreach tool,$(TOOLS),\
	$(call add_submake_hack,$(tool),tools/$(tool),tools_busybox)\
)

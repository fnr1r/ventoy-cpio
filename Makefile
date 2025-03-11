include scripts/here.mk

ARCHITECTURES := i386 x86_64 aarch64

ifndef TARGETS
	TARGETS := ARCHITECTURES
endif

export TARGETS

.PHONY: all build
all: build
build: submakes

include scripts/submake.mk

TOOLS := busybox device-mapper

$(foreach tool,$(TOOLS),\
	$(call add_submake_hack,$(tool),tools/$(tool),tools_busybox)\
)

include ../scripts/here.mk
include $(SCRIPTS_DIR)/shared.mk
include info.mk

ifndef TARGET
$(error TARGET is not defined)
endif

$(foreach t,$(TOOLS), \
	$(eval $t/dist/%: ; $$(MAKE) -C $t -f build.mk TARGET="$$(patsubst $t/dist/%,%,$$@)") \
)

all: $(TARGET)

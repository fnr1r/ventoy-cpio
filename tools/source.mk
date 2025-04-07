include ../scripts/here.mk
include $(SCRIPTS_DIR)/shared_source.mk
include info.mk

$(foreach a,clean clean-src clean-all download prepare,\
	$(eval $a: $(foreach t,$(TOOLS),$a/$t)) \
)

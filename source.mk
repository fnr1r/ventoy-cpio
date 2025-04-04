include scripts/here.mk
include $(SCRIPTS_DIR)/shared_source.mk

clean:
	-rm -r dist build

$(foreach a,clean clean-src clean-all download prepare,\
	$(eval $a: $(foreach t,tools,$a/$t)) \
)

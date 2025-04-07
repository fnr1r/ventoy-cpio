ifndef SCRIPTS_DIR
$(error SCRIPTS_DIR not set)
endif
include $(SCRIPTS_DIR)/shared_source.mk

clean:
	-rm -r build dist
clean-src: clean
clean-all: clean-src

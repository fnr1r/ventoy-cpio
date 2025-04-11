include ../scripts/here.mk
include $(SCRIPTS_DIR)/shared_main.mk
include info.mk

.PHONY: all build clean clean-src clean-all download prepare
all: build
build: $(TOOLS)


# intermittent failure here

# Example 1:
# make[3]: *** [source.mk:7: device-mapper.1.02.28.tgz] Error 4
# make[3]: Leaving directory '/build/tools/device-mapper'
# make[2]: Leaving directory '/build/tools/device-mapper'
# make[2]: *** [Makefile:11: src] Error 2
# make[1]: *** [Makefile:11: device-mapper] Error 2
# make[1]: *** Waiting for unfinished jobs....

# Example 2:
# make[3]: *** [source.mk:7: lunzip-1.11.tar.gz] Error 4
# checking for musl-gcc option to accept ISO C89... make[3]: Leaving directory '/build/tools/lunzip'
# make[2]: Leaving directory '/build/tools/lunzip'
# make[2]: *** [Makefile:11: src] Error 2
# make[1]: *** [Makefile:11: lunzip] Error 2
# make -f build.mk TARGET=x86_64-ash
# make[1]: *** Waiting for unfinished jobs....
.PHONY: $(TOOLS)
$(TOOLS):
	+$(MAKE) -C $@

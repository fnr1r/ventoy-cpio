include ../../scripts/here.mk
include $(SCRIPTS_DIR)/shared.mk

.PHONY: all busybox clean
all: busybox
busybox: busybox-1.27.1-i686 busybox-1.30.0-i686 busybox-1.31.0-i686-uclibc
clean:

# arg1: version
# arg2: binaries
define busyboxdl
$(eval
.PHONY: busybox-$1
$(foreach bin,$2,
busybox-$1: busybox-$1-$(bin)
$(call download_file,https://busybox.net/downloads/binaries/1.30.0-i686/busybox_$(shell echo '$(bin)' | tr '[:lower:]' '[:upper:]'),busybox-$1-$(bin))
.PHONY: clean-busybox-$1-$(bin)
clean-busybox-$1-$(bin):
	-rm busybox-$1-$(bin)
clean: clean-busybox-$1-$(bin)
)
)
endef

$(call busyboxdl,1.27.1-i686,ash xz)
$(call busyboxdl,1.30.0-i686,ar hexdump inotifyd xzcat)
$(call busyboxdl,1.31.0-i686-uclibc,ash)

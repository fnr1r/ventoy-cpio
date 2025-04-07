include ../scripts/here.mk
include $(SCRIPTS_DIR)/shared_main.mk
include info.mk

build/%: prepare
	+$(MAKE) -f build.mk TARGET="$(patsubst build/%,%,$@)"
clean:
	+$(MAKE) -f source.mk $@

BUSYBOX_TARGETS := $(foreach b,ash busybox hexdump xzcat,busybox/dist/{ARCH}/$b)
DMSETUP_TARGETS := device-mapper/dist/{ARCH}/dmsetup
LUNZIP_TARGETS := lunzip/dist/{ARCH}/lunzip
LZ4_TARGETS := lz4/dist/{ARCH}/lz4cat
UNSQUASHFS_TARGETS := squashfs/dist/{ARCH}/unsquashfs
VBLADE_TARGETS := vblade/dist/{ARCH}/vblade
VTCHMOD_TARGETS := vtchmod/dist/{ARCH}/vtchmod
VTOY_FUSE_ISO_TARGETS := vtoy_fuse_iso/dist/{ARCH}/vtoy_fuse_iso
VTOYTOOL_TARGETS := vtoytool/dist/{ARCH}/vtoytool
XZMINIDEC_TARGETS := xz-embedded/dist/{ARCH}/xzminidec
ZSTDCAT_TARGETS := zstd/dist/{ARCH}/zstdcat

M_X86_64_TARGETS := BUSYBOX DMSETUP LUNZIP LZ4 UNSQUASHFS VBLADE VTCHMOD \
	VTOY_FUSE_ISO VTOYTOOL XZMINIDEC ZSTDCAT
M_I386_TARGETS := BUSYBOX DMSETUP LUNZIP LZ4 UNSQUASHFS VBLADE VTCHMOD \
	VTOYTOOL XZMINIDEC ZSTDCAT
M_AARCH64_TARGETS := $(M_X86_64_TARGETS)
M_MIPS64EL_TARGETS := $(M_X86_64_TARGETS)
$(foreach a,$(BIN_ARCHES_ALL),$(eval \
MP_$(call uppercase,$a)_TARGETS := $(foreach t,$(foreach m,$(M_$(call uppercase,$a)_TARGETS),$($m_TARGETS)), $(shell \
	echo "$t" | sed -e 's/{ARCH}/$a/' \
)) \
))
build: $(addprefix build/,$(foreach a,$(BIN_ARCHES_ALL),$(MP_$(call uppercase,$a)_TARGETS)))

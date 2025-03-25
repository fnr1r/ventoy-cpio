#
# Makefile
#
# Author: Lasse Collin <lasse.collin@tukaani.org>
#
# This file has been put into the public domain.
# You can do whatever you want with this file.
#

ifndef ARCH
$(error "ARCH is undefined")
endif

EXTRACFLAGS := -Os -DXZ_DEC_CONCATENATED
# -std=gnu89: not used since it emits pointless warnings

ifeq ($(ARCH),i386)
CC := diet32 gcc -m32
else ifeq ($(ARCH),x86_64)
CC := diet gcc
else ifeq ($(ARCH),aarch64)
CC := aarch64-linux-gcc -static
else ifeq ($(ARCH),mips64el)
CC := mips64el-linux-musl-gcc -mips64r2 -mabi=64 -static
else
$(error "ARCH is unsupported")
endif

#CC = gcc -specs "/usr/local/musl/lib/musl-gcc.specs" -Os -static  -std=gnu89

CPPFLAGS = -DXZ_USE_CRC64 -DXZ_DEC_ANY_CHECK
CFLAGS = -ggdb3 -O2 -pedantic -Wall -Wextra $(EXTRACFLAGS)
RM = rm -f
VPATH = ../linux/include/linux ../linux/lib/xz
COMMON_SRCS = xz_crc32.c xz_crc64.c xz_dec_stream.c xz_dec_lzma2.c xz_dec_bcj.c
COMMON_OBJS = $(COMMON_SRCS:.c=.o)
XZMINIDEC_OBJS = xzminidec.o
BYTETEST_OBJS = bytetest.o
BUFTEST_OBJS = buftest.o
BOOTTEST_OBJS = boottest.o
XZ_HEADERS = xz.h xz_private.h xz_stream.h xz_lzma2.h xz_config.h
PROGRAMS = xzminidec bytetest buftest boottest

ALL_CPPFLAGS = -I../linux/include/linux -I. $(CPPFLAGS)

all: $(PROGRAMS)

%.o: %.c $(XZ_HEADERS)
	$(CC) $(ALL_CPPFLAGS) $(CFLAGS) -c -o $@ $<

xzminidec: $(COMMON_OBJS) $(XZMINIDEC_OBJS)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $(COMMON_OBJS) $(XZMINIDEC_OBJS)

bytetest: $(COMMON_OBJS) $(BYTETEST_OBJS)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $(COMMON_OBJS) $(BYTETEST_OBJS)

buftest: $(COMMON_OBJS) $(BUFTEST_OBJS)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $(COMMON_OBJS) $(BUFTEST_OBJS)

boottest: $(BOOTTEST_OBJS) $(COMMON_SRCS)
	$(CC) $(ALL_CPPFLAGS) $(CFLAGS) $(LDFLAGS) -o $@ $(BOOTTEST_OBJS)

.PHONY: clean
clean:
	-$(RM) $(COMMON_OBJS) $(XZMINIDEC_OBJS) $(BUFTEST_OBJS) \
		$(BOOTTEST_OBJS) $(PROGRAMS)

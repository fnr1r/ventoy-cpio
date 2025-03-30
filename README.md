# Ventoy CPIO

NOTE: This is just a small part of my attempt to add a sane(-ish) build system
to Ventoy.

## Goal

Make a replacement ramdisk for Ventoy

- [?] with a sane(-er) build system
- [x] a bootable one
- [ ] a functionally identical one  
  (a.k.a can do the same things as the upstream)
- [ ] a smaller one

### Non-goals

- ❌ a binary-identical ramdisk
  - compiling identical binaries with the instructions given would be near
  impossible and is ultimately pointless

### Possible future changes

- Removing suffixes from binaries (they're just annoying and inconsistent)  
  (no upsteam changes required)
- Splitting the ramdisks into x86 32-bit and 64-bit  
  (would require changes to grub)
- Cleaning up shell scripts in the ramdisk  
  (no upsteam changes required)

## Progress

It boots, but some functionality might not work.

### ventoy.cpio

100%, since it's literally just xz-ing a bunch of files.

Size ratio:

- du - 1 (64 / 64)
- ls -l - 1 (62976 / 62976)

### ventoy_ARCH.cpio

~75%

All the tools are here (mostly), compiled in one way or another. Now all that's
left is optimization.

Size ratio (x86):

- du - 1.002728512960437 (2940 / 2932)
- ls -l - 1.013273573521807 (3009536 / 2970112)

Size ratio (arm64):

- du - 0.8619854721549637 (1424 / 1652)
- ls -l - 0.8620375985445725 (1455616 / 1688576)

Size ratio (mips64):

- du - 1.402930402930403 (1532 / 1092)
- ls -l - 1.405231757687012 (1567744 / 1115648)

### vtloopex.cpio

TODO: add this

## Usage

### Building

```sh
docker compose build
```

```sh
docker compose up
```

Hint:

If you don't want to redownload archives every time you rebuild the container,
go to `docker/base/{dietlibc,musl,toolchains}`, look though the setup script
and manually `wget` the file.

You can also run this to enter the container:

```sh
docker run -it --rm \
  -v ".:/build" \
  ventoy-cpio-builder:latest \
  bash
```

### Setup

Once you have `ventoy*.cpio` files:

1. Mount the second partition on your Ventoy usb
1. !!! BACK UP THE ORIGINAL `ventoy*.cpio` FILES !!!
1. Copy the cpio you want to try out. (hint: if you don't know which one it is,
  then it's probably `ventoy_x86.cpio`)

## Mini TODO

- Build with an older version of Linux headers for compatibility

## Notes

- [In GCC terms](https://gcc.gnu.org/onlinedocs/gccint/Configure-Terms.html):
  - The build is assumed to be x86_64 *nix
  - The host (for ventoy installation tools) is assumed to be x86_64
  - The targets are x86_64, i386, aarch64 and mips64el

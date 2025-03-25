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

- du - 1,825375170532060 (5352 / 2932)
- ls -l - 1,845026719531115 (5479936 / 2970112)

Size ratio (arm64):

- du - 1,307506053268765 (2160 / 1652)
- ls -l - 1,309581564584597 (2211328 / 1688576)

Size ratio (mips64):

- du - 1,798534798534799 (1964 / 1092)
- ls -l - 1,802202845341900 (2010624 / 1115648)

### vtloopex.cpio

TODO: add this

## Building

```sh
docker compose build
docker compose up
```

## Notes

- [In GCC terms](https://gcc.gnu.org/onlinedocs/gccint/Configure-Terms.html):
  - The build is assumed to be x86_64 *nix
  - The host (for ventoy installation tools) is assumed to be x86_64
  - The targets are x86_64, i386, aarch64 and mips64el

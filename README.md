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

~50%

Size ratio (x86):

- du - 1,821282401091405 (5340 / 2932)
- ls -l - 1,840889501810033 (5467648 / 2970112)

Size ratio (arm64):

- du - 1,268765133171913 (2096 / 1652)
- ls -l - 1,271073377804730 (2146304 / 1688576)

Size ratio (mips64):

- du - 1,739926739926740 (1900 / 1092)
- ls -l - 1,741624598439651 (1943040 / 1115648)

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

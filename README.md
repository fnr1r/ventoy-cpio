# Ventoy CPIO

NOTE: This is just a small part of my attempt to add a sane(-ish) build system
to Ventoy.

## Progress

It boots, but some functionality might not work.

### ventoy.cpio

100%, since it's literally just xz-ing a bunch of files.

Size ratio:

- du - 1 (64 / 64)
- ls -l - 1.016129032258065 (64512 / 63488)

### ventoy_ARCH.cpio

~50%

Size ratio:

- du - 1.873124147339700 (5492 / 2932)
- ls -l - 1.872888585565603 (5620224 / 3000832)

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

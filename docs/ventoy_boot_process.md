# Boot process for Linux from Ventoy

## pre-init

1. Original ramdisk loaded by Ventoy
1. TRAILER removed from end
1. `init` is renamed to `xxxx`, `linuxrc` to `vtoyxrc`, `sbin` to `vtoy`,
    `sbin/init` is renamed to `vtoy/vtoy`.
1. Arch-independent ramdisk appended
1. Arch-dependent ramdisk appended (amd64 and i386 have a shared ramdisk)
1. ISO block map added

## init

### /sbin/init

1. Detect architecture based on busybox name (saved to `/ventoy/ventoy_arch`)
1. Extract busybox (xz-compressed, xzminidec)
1. Install busybox to `/ventoy/busybox`
1. Add busybox to `PATH`
1. (???) debugging stuff
1. (???) redhat shell redirect bug
1. Extract `ventoy_chain.sh.xz`, `ventoy_loop.sh.xz`, `hook.cpio.xz`, `tool.cpio.xz`, `loop.cpio.xz`.
1. Setup other tools
1. Pass to next init

### /ventoy/init

1. Get cmdline and version from /proc (mkdir it if it doesn't exist)
1. Debug pause
1. If cmdline contains `rdinit=/vtoy/vtoy` (aka `/sbin/init`), hand over to
`/ventoy/init_loop`.
1. Otherwhise, hand over to `/ventoy/init_chain`.

### /ventoy/tools/vtoytool_install.sh

1. (for: `ar`, `inotifyd`)  
    If busybox provides it, use the busybox version (and link it into tools).  
    Otherwhise link the version from tools to busybox's path.
1. Install `vtoytool`.
1. (on `x86`)  
    Install `vtoy_fuse_iso`, `unsquashfs` and `veritysetup`.

### /ventoy/init_loop

1. Extract injected files (if any).
1. (at some point there must have been step 2, but it was removed)
1. Source `vtoytool_install.sh`.
1. Pass to `/ventoy/ventoy_loop.sh`.

### /ventoy/init_chain

1. Extract the real initramfs.
    1. Remove possibly conflicting files.
1. ???
1. Extract injected files (if any).
1. Source `vtoytool_install.sh`.
1. Pass to `/ventoy/ventoy_loop.sh`.

### /ventoy/ventoy_loop.sh

1. `Process ko?`
1. OS-Specific hook (`loop` hooks preferred over `hook` hooks).
1. ???
1. Hand over to init.

### /ventoy/ventoy_chain.sh

1. OS-Specific hook (`loop` hooks preferred over `hook` hooks).
1. Run LiveInjection hook.
1. ???
1. Hand over to init.

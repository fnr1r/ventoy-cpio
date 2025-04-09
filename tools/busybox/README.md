# busybox

## Custom config notes

Based on: `01-defconfig-static.config`

### Changes

- Disabled `{u,w}tmp`: only running as root
- Disabled suid wrapper configuration: only running as root
- `MD5_SMALL` from `1` to `3`
- `LAST_SUPPORTED_WCHAR` changed to only support ASCII
- Disabled `IOCTL_HEX2STR_ERROR`: saves some space

- Enabled `ar`, `unlzop`, `lzopcat` and `uncompress`.

- Enabled nanosecond specifier for date (`FEATURE_DATE_NANO`)
- Removed `{,f}sync`: no need to sync to disk
- Removed `who`, `w`, `users`: only running as root

- Removed `awk` math extensions (`FEATURE_AWK_LIBM`): also disabled in upstream
- Removed `ed`: no need for additional editors

- Removed most Init Utilities
- Removed most Login/Password Management Utilities

- Enabled `tune2fs`: could be used by something

- Removed `last`: only running at boot and once
- Disabled mdev daemon mode `FEATURE_MDEV_DAEMON`
- Enabled mount helpers `FEATURE_MOUNT_HELPERS`: might be useful
- Removed `wall`: only running as root

- Removed `cron{d,tab}`: unneeded
- Enabled `inotifyd`: used by Ventoy
- Removed `runlevel`: unneeded

- Enabled `Support displaying rarely used link types` `FEATURE_IP_RARE_PROTOCOLS`
- Removed unneeded ntp stuff

- Removed Print Utilities

- Removed history support for shells

- Removed other probably unneeded stuff

### Possible future changes

- `SHA1_SMALL`: increasing this is impossible in the current version of BusyBox

## TODO

- (busybox config) Remove some more unneeded things

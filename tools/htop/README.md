# `htop`

This folder contains a `Dockerfile` adapted from `vercel/pkg-fetch`, which produces
a statically linked (musl) `htop` binary for armv7

UPX is currently (2022-05-09) commented out as the latest UPX release doesn't
like to compress armv7 binaries. The [latest CI build](https://github.com/upx/upx/actions)
does however work fine.

Because this builds a statically linked binary, it also runs on aarch64.

```
$ docker build --progress plain -t valetudo-htop-armv7 --output bin/ .
```

The resulting `htop` binary will be copied to `bin`, and because it is
statically-linked, it also runs on aarch64.

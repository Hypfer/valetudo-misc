This folder contains a dockerfile adapted from vercel/pkg-fetch, which produces a statically linked (musl) htop binary for armv7

UPX is currently (2022-05-09) commented out as the latest UPX release doesn't like to compress armv7 binaries.
A latest CI build does however work fine: https://github.com/upx/upx/actions


```
docker build --progress plain -t valetudo-htop-armv7 -f .\Dockerfile.alpine .
docker create valetudo-htop-armv7:latest 
docker cp [see previous command output]:/root/htop/htop-3.2.0/htop .
```

Because it's statically linked, it also runs on aarch64
# Calling NVML functions with Zig

I was just trying to see if I can make this work as I was learning Zig.

It worked inside the Docker image `nvidia/cuda:12.4.1-devel-ubuntu22.04`.

Zig version is 0.13.0.

```console
$ zig version
0.13.0
$ zig build run
Device name: NVIDIA A40
Current power usage: 79.472 W
```

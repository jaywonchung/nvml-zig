# Calling NVML functions with Zig

I was just trying to see if I can make this work as I was learning Zig.

I think it'll work in general on any system with CUDA installed; namely, the NVML shared object file (`libnvidia-ml.so`) in some well-known path and the NVML header file at `/usr/local/cuda/include/nvml.h`.

Confirmed working inside the Docker image `nvidia/cuda:12.4.1-devel-ubuntu22.04`.

```console
$ zig version
0.13.0
$ zig build run
Device name: NVIDIA A40
Power draw: 79.962 W
Temperature: 36°C
Utilization: 0 %
```

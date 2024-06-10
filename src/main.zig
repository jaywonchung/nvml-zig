const std = @import("std");
const nvml = @cImport({
    @cInclude("nvml.h");
});

pub fn main() !void {
    nvml_check(nvml.nvmlInit());

    // Get device handle for the first GPU.
    var dev: nvml.nvmlDevice_t = undefined;
    nvml_check(nvml.nvmlDeviceGetHandleByIndex(0, &dev));

    // Get the device's name.
    const name_len = nvml.NVML_DEVICE_NAME_BUFFER_SIZE;
    var name: [name_len]u8 = [_]u8{0} ** name_len;
    nvml_check(nvml.nvmlDeviceGetName(dev, &name, name_len));
    std.debug.print("Device name: {s}\n", .{name});

    // Get the device's current power draw.
    var power: u32 = undefined;
    nvml_check(nvml.nvmlDeviceGetPowerUsage(dev, &power));
    std.debug.print("Power draw: {d:.3} W\n", .{
        @as(f32, @floatFromInt(power)) / 1000,
    });

    // Get the device's current temperature.
    var temp: u32 = undefined;
    nvml_check(nvml.nvmlDeviceGetTemperature(dev, nvml.NVML_TEMPERATURE_GPU, &temp));
    std.debug.print("Temperature: {d}°C\n", .{temp});

    // Get the device's current utilization.
    var util: nvml.nvmlUtilization_t = undefined;
    nvml_check(nvml.nvmlDeviceGetUtilizationRates(dev, &util));
    std.debug.print("Utilization: {d} %\n", .{util.gpu});

    nvml_check(nvml.nvmlShutdown());
}

fn nvml_check(ret: nvml.nvmlReturn_t) void {
    if (ret != nvml.NVML_SUCCESS) {
        const message: [*:0]const u8 = nvml.nvmlErrorString(ret);
        std.debug.print("NVML error: {s}\n", .{message});
        std.process.exit(1);
    }
}

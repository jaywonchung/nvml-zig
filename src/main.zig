const std = @import("std");
const nvml = @cImport({
    @cInclude("nvml.h");
});

fn nvml_check(ret: nvml.nvmlReturn_t) void {
    if (ret != nvml.NVML_SUCCESS) {
        std.debug.print("NVML error: {}\n", .{ret});
        std.process.exit(1);
    }
}

pub fn main() !void {
    nvml_check(nvml.nvmlInit());

    var dev: *nvml.struct_nvmlDevice_st = undefined;
    nvml_check(nvml.nvmlDeviceGetHandleByIndex(0, @ptrCast(&dev)));

    // Get the device's name.
    const name_len = nvml.NVML_DEVICE_NAME_BUFFER_SIZE;
    var name: [name_len]u8 = undefined;
    nvml_check(nvml.nvmlDeviceGetName(dev, &name, name_len));
    std.debug.print("Device name: {s}\n", .{name});

    // Get the device's current power draw.
    var power: u32 = undefined;
    nvml_check(nvml.nvmlDeviceGetPowerUsage(dev, &power));
    std.debug.print("Current power usage: {d:.3} W\n", .{@as(f32, @floatFromInt(power)) / 1000});

    // Reset the device's power limit to the default value.
    var default_pl: u32 = undefined;
    nvml_check(nvml.nvmlDeviceGetPowerManagementDefaultLimit(dev, &default_pl));
    nvml_check(nvml.nvmlDeviceSetPowerManagementLimit(dev, default_pl));
    std.debug.print("Power limit reset to default ({d} W)\n", .{@as(f32, @floatFromInt(default_pl)) / 1000});

    nvml_check(nvml.nvmlShutdown());
}

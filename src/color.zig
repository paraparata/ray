const std = @import("std");
const vec3 = @import("vec3.zig");

pub const Color = vec3.Vec3;

pub fn print(stdout: std.io.AnyWriter, pixel_color: Color) !void {
    const rr = pixel_color.x;
    const gg = pixel_color.y;
    const bb = pixel_color.z;

    const r: u8 = @intFromFloat(255.99 * rr);
    const g: u8 = @intFromFloat(255.99 * gg);
    const b: u8 = @intFromFloat(255.99 * bb);

    try stdout.print("{} {} {}", .{ r, g, b });
}

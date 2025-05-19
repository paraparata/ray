const std = @import("std");
const Vector3 = @import("vec.zig").Vector3;

pub const Color = Vector3;

pub fn print(stdout: std.io.AnyWriter, pixel_color: Color) !void {
    const rr = pixel_color[0];
    const gg = pixel_color[1];
    const bb = pixel_color[2];

    const r: u8 = @intFromFloat(255.99 * rr);
    const g: u8 = @intFromFloat(255.99 * gg);
    const b: u8 = @intFromFloat(255.99 * bb);

    try stdout.print("{} {} {}", .{ r, g, b });
}

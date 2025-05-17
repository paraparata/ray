const std = @import("std");
const vec = @import("vec.zig");

pub const Color = vec.Vector;

pub fn print(stdout: std.io.AnyWriter, pixel_color: Color) !void {
    const rr = pixel_color.e[0];
    const gg = pixel_color.e[1];
    const bb = pixel_color.e[2];

    const r: u8 = @intFromFloat(255.99 * rr);
    const g: u8 = @intFromFloat(255.99 * gg);
    const b: u8 = @intFromFloat(255.99 * bb);

    try stdout.print("{} {} {}", .{ r, g, b });
}

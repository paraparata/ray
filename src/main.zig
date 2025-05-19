const std = @import("std");
const vec = @import("vec.zig");
const ray = @import("ray.zig");
const color = @import("color.zig");
const Color = color.Color;

const page_alloc = std.heap.page_allocator;

pub fn main() !void {
    // Prints to stderr (it's a shortcut based on `std.io.getStdErr()`)
    std.debug.print("Ray Processing...\n", .{});

    // Get arguments
    const args = try std.process.argsAlloc(page_alloc);
    defer std.process.argsFree(page_alloc, args);

    // process.args will always has at least one argument: path of executable program
    if (args.len < 2) {
        return error.ExpectedArgument;
    }

    // Since we only need a filename. We don't need more arguments
    if (args.len != 2) {
        return error.ExpectedOnlyOneFilename;
    }

    const filename = args[1];

    // String concatenation
    // Refer to test_slice.zig in https://ziglang.org/documentation/master/#Slices
    var start_index: usize = 0;
    _ = &start_index;
    var path_arr: [100]u8 = undefined;
    const path_slice = path_arr[start_index..];
    // Output generated file to `generated` directory
    const path = try std.fmt.bufPrint(path_slice, "generated/{s}", .{filename});

    const file = try std.fs.cwd().createFile(path, .{});
    defer file.close();

    // Buffered i/o is preferred
    // https://pedropark99.github.io/zig-book/Chapters/12-file-op.html#buffered-io
    var bw = std.io.bufferedWriter(file.writer());
    const stdout = bw.writer();

    try generator(stdout.any());

    try bw.flush();
    std.debug.print("Done.\n", .{});
}

fn rayColor(r: ray.Ray) Color {
    const unit_direction = r.direction.unit();
    const a = 0.5 * (unit_direction.y() + 1.0);
    return Color.init(1, 1, 1).multiply(0.5).add(Color.init(1, 0, 0).multiply(a));
}

fn generator(stdout: std.io.AnyWriter) !void {
    // image
    const aspect_ratio = 16.0 / 9.0;
    const width = 400;

    // calculate image to at least has height >= 1
    const height = blk: {
        const h: comptime_int = @intFromFloat(@as(comptime_float, width) / aspect_ratio);
        break :blk if (h < 1) 1 else h;
    };

    // camera
    const focal_len = 1.0;
    const viewport_height = 2.0;
    const fwidth: comptime_float = @floatFromInt(width);
    const fheight: comptime_float = @floatFromInt(height);
    const viewport_width: comptime_float = viewport_height * (fwidth / fheight);
    const camera_center: vec.Point = .default;

    const viewport_u: vec.Vector = .init(viewport_width, 0, 0);
    const viewport_v: vec.Vector = .init(0, -viewport_height, 0);

    const pixel_delta_u = viewport_u.div(fwidth);
    const pixel_delta_v = viewport_v.div(fwidth);

    const viewport_upper_left: vec.Vector = camera_center.substract(vec.Vector.initFromBuiltin(@Vector(3, f64){ 0, 0, focal_len } -
        viewport_u.div(2.0).e -
        viewport_v.div(2.0).e));
    const pixel00_loc = viewport_upper_left.add(pixel_delta_u.add(pixel_delta_v)).multiply(0.5);

    try stdout.print("P3\n{} {}\n{}\n", .{ width, height, 255 });

    for (0..height) |y| {
        for (0..width) |x| {
            const fx: f64 = @floatFromInt(x);
            const fy: f64 = @floatFromInt(y);
            const pixel_sum = pixel_delta_u.multiply(fx).add(pixel_delta_v.multiply(fy));
            const pixel_center = pixel00_loc.add(pixel_sum);
            const ray_direction = pixel_center.substract(camera_center);
            const r: ray.Ray = .init(camera_center, ray_direction);
            const pixel_color = rayColor(r);

            try color.print(stdout, pixel_color);
            try stdout.print("\n", .{});
        }
    }
}

fn originGenerator(stdout: std.io.AnyWriter) !void {
    const width = 256;
    const height = 256;

    try stdout.print("P3\n{} {}\n{}\n", .{ width, height, 255 });

    for (0..height) |y| {
        for (0..width) |x| {
            const fr: f16 = @as(f16, @floatFromInt(x)) / @as(f16, @floatFromInt(width - 1));
            const fg: f16 = @as(f16, @floatFromInt(y)) / @as(f16, @floatFromInt(height - 1));
            const fb = 0.0;
            const pixel_color: Color = .init(fr, fg, fb);

            try color.print(stdout, pixel_color);
            try stdout.print("\n", .{});
        }
    }
}

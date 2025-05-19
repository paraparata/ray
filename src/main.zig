const std = @import("std");
const vec = @import("vec.zig");
const Vector3 = vec.Vector3;
const Point = vec.Point;
const Ray = @import("ray.zig").Ray;
const color = @import("color.zig");
const Color = color.Color;

const page_alloc = std.heap.page_allocator;

pub fn main() !void {
    // Prints to stderr (it's a shortcut based on `std.io.getStdErr()`)
    std.debug.print("Ray Initializating...\n", .{});

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

    std.debug.print("Ray Procesing {s}...\n", .{path});

    // Buffered i/o is preferred
    // https://pedropark99.github.io/zig-book/Chapters/12-file-op.html#buffered-io
    var bw = std.io.bufferedWriter(file.writer());
    const stdout = bw.writer();

    try generator(stdout.any());

    try bw.flush();
    std.debug.print("Done.\n", .{});
}

fn rayColor(r: Ray) Color {
    const unit_direction = vec.unit(r.direction);
    const a: f64 = 0.5 * (unit_direction[1] + 1.0);
    return vec.multiply(Color{ 1, 1, 1 }, @as(f64, 1) - a) +
        vec.multiply(Color{ 0.89, 0.58, 0.21 }, a);
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
    const camera_center: Point = .{ 0, 0, 0 };

    // viewport
    const viewport_u: Vector3 = .{ viewport_width, 0, 0 };
    const viewport_v: Vector3 = .{ 0, -viewport_height, 0 };

    // length of 1 pixel
    const pixel_delta_u = vec.div(viewport_u, fwidth);
    const pixel_delta_v = vec.div(viewport_v, fheight);

    // focal len is the distance between the point of view ("eye") to image object
    const focal_len_vec: Vector3 = .{ 0, 0, focal_len };
    // position of image upper left corner relatives to camera center
    const viewport_upper_left = camera_center - focal_len_vec - vec.div(viewport_u, 2) - vec.div(viewport_v, 2);
    const pixel00_loc = viewport_upper_left + vec.multiply(pixel_delta_u + pixel_delta_v, 0.5);

    try stdout.print("P3\n{} {}\n{}\n", .{ width, height, 255 });

    for (0..height) |y| {
        for (0..width) |x| {
            const fx: f64 = @floatFromInt(x);
            const fy: f64 = @floatFromInt(y);
            const pixel_center = pixel00_loc + vec.multiply(pixel_delta_u, fx) + vec.multiply(pixel_delta_v, fy);
            const ray_direction = pixel_center - camera_center;
            const r: Ray = .init(camera_center, ray_direction);
            const pixel_color = rayColor(r);

            try color.print(stdout, pixel_color);
            try stdout.print("\n", .{});
        }
    }
}

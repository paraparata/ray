const std = @import("std");
const color = @import("color.zig");

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

    const width = 256;
    const height = 256;

    try stdout.print("P3\n{} {}\n{}\n", .{ width, height, 255 });

    for (0..height) |y| {
        for (0..width) |x| {
            const fr: f16 = @as(f16, @floatFromInt(x)) / @as(f16, @floatFromInt(width - 1));
            const fg: f16 = @as(f16, @floatFromInt(y)) / @as(f16, @floatFromInt(height - 1));
            const fb = 0.0;
            const pixel_color: color.Color = .init(fr, fg, fb);

            try color.print(stdout.any(), pixel_color);
            try stdout.print("\n", .{});
        }
    }

    try bw.flush();
    std.debug.print("Done.\n", .{});
}

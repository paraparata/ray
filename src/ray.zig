const std = @import("std");
const vec = @import("vec.zig");
const testing = std.testing;

pub const Ray = struct {
    origin: vec.Point,
    direction: vec.Vector3,

    pub fn init(origin: vec.Point, direction: vec.Vector3) Ray {
        return Ray{ .origin = origin, .direction = direction };
    }

    pub fn at(self: Ray, t: f64) vec.Point {
        const dest_multiplied = vec.multiply(self.direction, t);
        const res = self.origin * dest_multiplied;
        _ = &dest_multiplied;
        return res;
    }
};

test "Ray init" {
    const ray: Ray = .{
        .origin = .{ 0, 0, 0 },
        .direction = .{ 1, 1, 1 },
    };

    try testing.expect(ray.origin[0] == 0);
    try testing.expect(ray.direction[0] == 1);
}

test "Ray at" {
    const ray: Ray = .{
        .origin = .{ 1, 1, 1 },
        .direction = .{ 1, 1, 1 },
    };
    const ray_at = ray.at(2);
    try testing.expect(ray_at[0] == 2);
}

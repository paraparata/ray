const std = @import("std");
const vec = @import("vec.zig");
const testing = std.testing;

pub const Ray = struct {
    origin: vec.Point,
    direction: vec.Vector,

    pub fn init(origin: vec.Point, direction: vec.Vector) Ray {
        return Ray{ .origin = origin, .direction = direction };
    }

    pub fn at(self: Ray, t: f64) vec.Point {
        const dest_multiplied = self.direction.multiply(t);
        const res = self.origin.multiplyVec(dest_multiplied);
        _ = &dest_multiplied;
        return res;
    }
};

test "Ray init" {
    const ray: Ray = .{
        .origin = .default,
        .direction = vec.Vector{ .e = .{ 1, 1, 1 } },
    };

    try testing.expect(ray.origin.e[0] == 0);
    try testing.expect(ray.direction.e[0] == 1);
}

test "Ray at" {
    const ray: Ray = .{
        .origin = vec.Vector{ .e = .{ 1, 1, 1 } },
        .direction = vec.Vector{ .e = .{ 1, 1, 1 } },
    };
    const ray_at = ray.at(2);
    try testing.expect(ray_at.e[0] == 2);
}

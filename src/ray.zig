const std = @import("std");
const vec = @import("vec.zig");
const testing = std.testing;

pub const Ray = struct {
    origin: vec.Point,
    direction: vec.Vector3,

    pub fn init(origin: vec.Point, direction: vec.Vector3) Ray {
        return Ray{ .origin = origin, .direction = direction };
    }

    /// Vector of ray at some point along the way
    /// P(t) = origin + t*destination
    pub fn at(self: Ray, t: f64) vec.Point {
        const res = self.origin + vec.multiply(self.direction, t);
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

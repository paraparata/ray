const std = @import("std");
const math = std.math;

pub const Point3 = Vec3;

// TODO: Implement on separeted module Vec3 with @Vector (https://ziglang.org/documentation/master/#Vectors)
pub const Vec3 = struct {
    x: f64,
    y: f64,
    z: f64,

    const default: Vec3 = .{ .x = 0, .y = 0, .z = 0 };

    pub fn add(self: *Vec3, with_vec: Vec3) *Vec3 {
        self.x += with_vec.x;
        self.y += with_vec.x;
        self.z += with_vec.z;
        return self;
    }

    pub fn multiply(self: *Vec3, t: f64) *Vec3 {
        self.x *= t;
        self.y *= t;
        self.z *= t;

        return self;
    }

    pub fn div(self: *Vec3, t: f64) *Vec3 {
        return self.multiply(1 / t);
    }

    pub fn len(self: Vec3) f64 {
        return @sqrt(self.x * self.x +
            self.y * self.y +
            self.z * self.z);
    }
};

pub fn print(vec: Vec3) []u8 {
    var buf: [100]u8 = undefined;
    return std.fmt.bufPrint(&buf, "{d} {d} {d}", .{ vec.x, vec.y, vec.z });
}

pub fn add(a: Vec3, b: Vec3) Vec3 {
    return .{ .x = a.x + b.x, .y = a.y + b.y, .z = a.z + b.z };
}

pub fn substract(a: Vec3, b: Vec3) Vec3 {
    return .{ .x = a.x - b.x, .y = a.y - b.y, .z = a.z - b.z };
}

pub fn multiplyVecs(a: Vec3, b: Vec3) Vec3 {
    return .{ .x = a.x * b.x, .y = a.y * b.y, .z = a.z * b.z };
}

pub fn multiply(a: Vec3, t: f64) Vec3 {
    return .{ .x = a.x * t, .y = a.y * t, .z = a.z * t };
}

pub fn div(a: Vec3, t: f64) Vec3 {
    return multiply(a, 1 / t);
}

pub fn dot(a: Vec3, b: Vec3) f64 {
    return a.x * b.x + a.y * b.y + a.z * b.z;
}

pub fn cross(a: Vec3, b: Vec3) Vec3 {
    return .{
        .x = a.y * b.z - a.z * b.y,
        .y = a.z * b.x - a.x * b.z,
        .z = a.x * b.y - a.y * b.x,
    };
}

test "Vec3 init default value test" {
    const vec: Vec3 = .default;
    const f0 = @as(f64, 0);
    try std.testing.expectEqual(vec.x, f0);
}

test "Vec3 add method test" {
    var a: Vec3 = .default;
    const b: Vec3 = .{ .x = 1, .y = 1, .z = 1 };
    _ = a.add(b);
    try std.testing.expectEqual(a.x, 1);
    try std.testing.expectEqual(a.y, 1);
    try std.testing.expectEqual(a.z, 1);
}

test "Vec3 multiply method test" {
    var a: Vec3 = .{ .x = 2, .y = 3, .z = 4 };
    _ = a.multiply(2);
    try std.testing.expectEqual(a.x, 4);
    try std.testing.expectEqual(a.y, 6);
    try std.testing.expectEqual(a.z, 8);
}

test "Vec3 div method test" {
    var a: Vec3 = .{ .x = 4, .y = 6, .z = 8 };
    _ = a.div(2);
    try std.testing.expectEqual(a.x, 2);
    try std.testing.expectEqual(a.y, 3);
    try std.testing.expectEqual(a.z, 4);
}

test "Vec3 len method test" {
    const a: Vec3 = .{ .x = 1, .y = 1, .z = 1 };
    try std.testing.expectEqual(a.len(), @sqrt(@as(f64, 3)));
}

test "Vec3 add fn test" {
    const a: Vec3 = .default;
    const b: Vec3 = .{ .x = 1, .y = 1, .z = 1 };
    const c = add(a, b);
    try std.testing.expectEqual(c.x, 1);
    try std.testing.expectEqual(c.y, 1);
    try std.testing.expectEqual(c.z, 1);
}

test "Vec3 substract fn test" {
    const a: Vec3 = .{ .x = 1, .y = 1, .z = 1 };
    const b: Vec3 = .{ .x = 1, .y = 1, .z = 1 };
    const c = substract(a, b);
    try std.testing.expectEqual(c.x, 0);
    try std.testing.expectEqual(c.y, 0);
    try std.testing.expectEqual(c.z, 0);
}

test "Vec3 multiplyVecs fn test" {
    const a: Vec3 = .default;
    const b: Vec3 = .{ .x = 1, .y = 1, .z = 1 };
    const c = multiplyVecs(a, b);
    try std.testing.expectEqual(c.x, 0);
    try std.testing.expectEqual(c.y, 0);
    try std.testing.expectEqual(c.z, 0);
}

test "Vec3 dot fn test" {
    const a: Vec3 = .{ .x = 3, .y = 3, .z = 3 };
    const b: Vec3 = .{ .x = 1, .y = 1, .z = 1 };
    const c = dot(a, b);
    try std.testing.expectEqual(c, @as(f64, 9));
}

test "Vec3 cross fn test" {
    const a: Vec3 = .{ .x = 3, .y = 2, .z = 1 };
    const b: Vec3 = .{ .x = 1, .y = 2, .z = 3 };
    const c = cross(a, b);
    try std.testing.expectEqual(c.x, @as(f64, 4));
    try std.testing.expectEqual(c.y, @as(f64, -8));
    try std.testing.expectEqual(c.z, @as(f64, 4));
}

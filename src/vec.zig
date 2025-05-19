const std = @import("std");
const testing = std.testing;

pub const Vector3 = @Vector(3, f64);
pub const Point = Vector3;

pub fn multiply(v: Vector3, t: f64) Vector3 {
    return Vector3{
        v[0] * t,
        v[1] * t,
        v[2] * t,
    };
}

pub fn div(v: Vector3, t: f64) Vector3 {
    const divider: f64 = 1;
    return multiply(v, divider / t);
}

pub fn len(v: Vector3) f64 {
    return @sqrt(v[0] * v[0] +
        v[1] * v[1] +
        v[2] * v[2]);
}

pub fn unit(v: Vector3) Vector3 {
    return .{
        v[0] / len(v),
        v[1] / len(v),
        v[2] / len(v),
    };
}

pub fn dot(a: Vector3, b: Vector3) f64 {
    return a[0] * b[0] + a[1] * b[1] + a[2] * b[2];
}

pub fn cross(a: Vector3, b: Vector3) Vector3 {
    return .{
        .x = a[1] * b[2] - a[2] * b[1],
        .y = a[2] * b[0] - a[0] * b[2],
        .z = a[0] * b[1] - a[1] * b[0],
    };
}

// to test if @TypeOf returns a type or a string of type
test "generic add" {
    const a: Vector3 = .{ 0, 0, 0 };
    const thetype = @TypeOf(a);
    try testing.expectEqual(thetype, Vector3);
}

test "Vector3  div test" {
    var a: Vector3 = .{ 4, 6, 8 };
    a = div(a, 2);
    try std.testing.expectEqual(a[0], 2);
    try std.testing.expectEqual(a[1], 3);
    try std.testing.expectEqual(a[2], 4);
}

test "vector 3d" {
    const v3: Vector3 = .{ 0, 0, 0 };
    try comptime testing.expect(v3[0] == 0);
}

test "vector unit" {
    const a: Vector3 = .{ 6, 8, 0 };
    const float6: f64 = 6;
    const float8: f64 = 8;
    const float10: f64 = 10;
    const comparison = unit(a) == @Vector(3, f64){ float6 / float10, float8 / float10, 0 };
    const is_all_true = @reduce(.And, comparison);
    try testing.expect(is_all_true == true);
}

test "vector res" {
    const v = @Vector(2, i8);
    const y = @as(v, @splat(0));
    const bb = v{ 1, -1 };
    const res = bb > y;
    try comptime testing.expect(res[0] == true);
    try comptime testing.expect(res[1] == false);

    const z: v = .{ 2, 2 };
    var d = z;
    d[0] = 3;
    try testing.expect(z[0] == 2);
    try testing.expect(d[0] == 3);
}

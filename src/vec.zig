const std = @import("std");
const testing = std.testing;

pub const Point = Vector;

pub const Vector = struct {
    e: @Vector(3, f64),

    pub const default: Vector = .{ .e = @Vector(3, f64){ 0, 0, 0 } };

    pub fn init(x: f64, y: f64, z: f64) Vector {
        return Vector{ .e = .{ x, y, z } };
    }

    pub fn add(self: Vector, b: Vector) Vector {
        return Vector{ .e = .{
            self.e[0] + b.e[0],
            self.e[1] + b.e[1],
            self.e[2] + b.e[2],
        } };
    }

    pub fn substract(self: Vector, b: Vector) Vector {
        return Vector{ .e = .{
            self.e[0] - b.e[0],
            self.e[1] - b.e[1],
            self.e[2] - b.e[2],
        } };
    }

    pub fn multiplyVec(self: Vector, b: Vector) Vector {
        return Vector{ .e = self.e * b.e };
    }

    pub fn multiply(self: Vector, t: f64) Vector {
        return Vector{ .e = .{
            self.e[0] * t,
            self.e[1] * t,
            self.e[2] * t,
        } };
    }

    pub fn div(self: Vector, t: f64) Vector {
        const divider: f64 = 1;
        return self.multiply(divider / t);
    }

    pub fn len(self: Vector) f64 {
        return @sqrt(self.e[0] * self.e[0] +
            self.e[1] * self.e[1] +
            self.e[2] * self.e[2]);
    }

    pub fn unit(self: Vector) @Vector(3, f64) {
        const e_unit: @Vector(3, f64) = .{
            self.e[0] / self.len(),
            self.e[1] / self.len(),
            self.e[2] / self.len(),
        };
        return e_unit;
    }
};

pub fn dot(a: Vector, b: Vector) f64 {
    return a.e[0] * b.e[0] + a.e[1] * b.e[1] + a.e[2] * b.e[2];
}

pub fn cross(a: Vector, b: Vector) Vector {
    return .{
        .x = a.e[1] * b.e[2] - a.e[2] * b.e[1],
        .y = a.e[2] * b.e[0] - a.e[0] * b.e[2],
        .z = a.e[0] * b.e[1] - a.e[1] * b.e[0],
    };
}

test "vector 3d" {
    const v3: Vector = .default;
    try comptime testing.expect(v3.e[0] == 0);
}

test "vector unit" {
    const a: Vector = .{ .e = .{ 6, 8, 0 } };
    const float6: f64 = 6;
    const float8: f64 = 8;
    const float10: f64 = 10;
    const comparison = a.unit() == @Vector(3, f64){ float6 / float10, float8 / float10, 0 };
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

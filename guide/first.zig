const std = @import("std");
const gpa = std.heap.GeneralPurposeAllocator;
const eq = std.testing.expectEqual;

const User = struct {
    id: []u8,
    name: []u8,
    surname: []u8,
    pub fn init(id: []const u8, name: []const u8, surname: []const u8) User {
        return .{ id, name, surname };
    }
};

pub fn allo() !void {
    var all = gpa(.{}){};
    defer _ = all.deinit();
    const allocator = all.allocator();

    const p = try allocator.create(i32);
    defer allocator.destroy(p);
    p.* = 3;
    std.debug.print("{*}", .{p});
}

pub fn main() !void {
    try allo();
}

test "some stuff" {
    const u = User.init("someId", "mario", "cacca");
    try eq("mario", u.name);
}

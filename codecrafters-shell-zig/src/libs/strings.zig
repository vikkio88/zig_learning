const std = @import("std");
const testing = std.testing;

pub fn eql(a: []const u8, b: []const u8) bool {
    return std.mem.eql(u8, a, b);
}

test "eql" {
    try testing.expect(eql("ciao", "ciao"));
}

pub fn contains(haystack: []const u8, needle: []const u8) bool {
    return std.mem.containsAtLeast(u8, haystack, 1, needle);
}

test "contains" {
    try testing.expect(contains("ciaone", "ciao"));
}

pub fn startsWith(str: []const u8, prefix: []const u8) bool {
    if (str.len < prefix.len) return false;
    for (prefix, 0..) |c, i| {
        if (c != str[i]) {
            return false;
        }
    }
    return true;
}

test "startWith" {
    const input = try std.testing.allocator.dupe(u8, "ciao banana");
    defer std.testing.allocator.free(input);

    try testing.expect(startsWith(input, "ciao"));
    try testing.expectEqual(false, startsWith(input, "ciax"));
}

pub fn removeStr(allocator: std.mem.Allocator, substr: []const u8, str: []u8) []u8 {
    const newString = std.mem.replaceOwned(u8, allocator, str, substr, "") catch return str;
    return newString;
}

test "removeStr" {
    const input = try std.testing.allocator.dupe(u8, "ciao banana");
    defer std.testing.allocator.free(input);

    try testing.expect(eql("banana", removeStr(std.testing.allocator, "ciao ", input)));
}

pub fn split(allocator: std.mem.Allocator, str: []const u8, delimiter: []const u8) !std.ArrayList([]const u8) {
    var list = std.ArrayList([]const u8).init(allocator);
    var it = std.mem.splitSequence(u8, str, delimiter);
    while (it.next()) |p| {
        try list.append(p);
    }

    return list;
}

test "split" {
    const result = try split(testing.allocator, "ciao:ciao", ":");
    defer result.deinit();

    try testing.expect(result.items.len == 2);
    try testing.expect(eql("ciao", result.items[0]));
    try testing.expect(eql("ciao", result.items[1]));
}

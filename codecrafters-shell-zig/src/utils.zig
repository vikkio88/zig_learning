const str = @import("./libs/strings.zig");
const std = @import("std");
const testing = std.testing;

pub fn strInArray(needle: []const u8, haystack: []const []const u8) bool {
    for (haystack) |s| {
        if (str.contains(s, needle)) {
            return true;
        }
    }

    return false;
}

test "strInArray" {
    const hay = .{ "echo", "exit", "ciao" };
    try testing.expect(strInArray("ciao", &hay));
    try testing.expectEqual(false, strInArray("mariano", &hay));
}

pub fn getMatchInArray(needle: []const u8, haystack: []const []const u8) ?[]const u8 {
    for (haystack) |s| {
        if (str.contains(s, needle)) {
            return s;
        }
    }

    return null;
}

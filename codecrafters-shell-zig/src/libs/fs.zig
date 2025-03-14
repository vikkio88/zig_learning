const std = @import("std");
const testing = std.testing;
const str = @import("./strings.zig");

pub fn getFolderForFile(allocator: std.mem.Allocator, filename: []const u8, folder_paths: []const []const u8) ?[]const u8 {
    for (folder_paths) |f| {
        const full_path = std.fs.path.join(allocator, &[_][]const u8{ f, filename }) catch return null;
        defer allocator.free(full_path);
        std.fs.accessAbsolute(full_path, .{ .mode = .read_only }) catch {
            continue;
        };
        return allocator.dupe(u8, full_path) catch null;
    }

    return null;
}

test "getFolderForFile" {
    const paths = .{ "/Users/vikkio/sides/codecrafters-shell-zig", "./Users/vikkio/sides/" };
    const result = getFolderForFile(testing.allocator, "your_program.sh", &paths);
    defer testing.allocator.free(result.?);
    try testing.expect(result != null);
    try testing.expect(str.eql("/Users/vikkio/sides/codecrafters-shell-zig/your_program.sh", result.?));
}

pub fn pwd(allocator: std.mem.Allocator) ?[]const u8 {
    return std.fs.cwd().realpathAlloc(allocator, ".") catch null;
}

test "cwd" {
    const res = pwd(testing.allocator);
    defer testing.allocator.free(res.?);
    try testing.expect(res != null);
}

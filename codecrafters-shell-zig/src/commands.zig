const std = @import("std");

pub fn handleEcho(sentences: [][]const u8) !void {
    const stdout = std.io.getStdOut().writer();
    for (sentences, 0..) |sentence, i| {
        try stdout.print("{s}", .{sentence});

        if (i < (sentence.len - 1))
            try stdout.print(" ", .{});
    }

    try stdout.print("\n", .{});
}

const std = @import("std");
const mem = std.mem;
const fs = @import("./libs/fs.zig");
const str = @import("./libs/strings.zig");
const utils = @import("./utils.zig");
const cmd = @import("./commands.zig");

const path_env = "PATH";
const available_commands = [_][]const u8{ "echo", "exit", "type", "pwd" };

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    const allocator = std.heap.page_allocator;
    const env_map = try std.process.getEnvMap(allocator);
    const path = env_map.get(path_env) orelse "";
    const path_commands = try str.split(allocator, path, ":");
    defer path_commands.deinit();

    const stdin = std.io.getStdIn().reader();
    // NOTE: this allow us only to get 1024 chars
    var buffer: [1024]u8 = undefined;
    while (true) {
        try stdout.print("$ ", .{});
        const user_input = try stdin.readUntilDelimiter(&buffer, '\n');
        var args = try str.split(allocator, user_input, " ");
        defer args.deinit();

        const command = args.items[0];
        const command_args = args.items[1..];

        if (str.eql("exit 0", user_input)) {
            break;
        }

        if (str.eql(command, "echo")) {
            try cmd.handleEcho(command_args);
            continue;
        }

        if (str.eql(command, "type")) {
            const command_arg = command_args[0];

            if (utils.getMatchInArray(command_arg, &available_commands)) |_clean| {
                try stdout.print("{s} is a shell builtin\n", .{_clean});
                continue;
            }

            const match = fs.getFolderForFile(allocator, command_arg, path_commands.items);
            defer if (match) |res| allocator.free(res);

            if (match == null) {
                try stdout.print("{s}: not found\n", .{command_arg});
                continue;
            }

            try stdout.print("{s} is {s}\n", .{ command_arg, match.? });
            continue;
        }

        // part 8
        // pwd
        if (str.eql(command, "pwd")) {
            const res = fs.pwd(allocator);
            defer if (res) |ptr| allocator.free(ptr);

            if (res) |d| {
                try stdout.print("{s}\n", .{d});
            }
            continue;
        }

        // part 7
        // exec external script if not matching internal command
        // get the command
        const match = fs.getFolderForFile(allocator, command, path_commands.items);
        defer if (match) |res| allocator.free(res);

        if (match != null) {
            const proc_result = try std.process.Child.run(.{ .allocator = allocator, .argv = args.items });
            try stdout.print("{s}", .{proc_result.stdout});
            continue;
        }

        try stdout.print("{s}: command not found\n", .{user_input});
    }
}

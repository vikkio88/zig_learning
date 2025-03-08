const std = @import("std");
const enums = @import("./enums.zig");

const Currency = enums.Currency;

pub const Money = struct {
    value: i32,
    currency: Currency,
    pub fn make(amount: i32, currency: Currency) Money {
        return .{ .value = amount, .currency = currency };
    }

    pub fn format(
        money: Money,
        comptime _: []const u8,
        _: std.fmt.FormatOptions,
        writer: anytype,
    ) !void {
        try writer.print("{} {s}\n", .{ money.value, money.currency.toSymbol() });
    }
};

test "can build money" {}

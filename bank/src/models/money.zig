const std = @import("std");
const testing = std.testing;

const enums = @import("./enums.zig");

const Currency = enums.Currency;

const Money = @This();
value: i32,
currency: Currency,

pub fn make(amount: i32, currency: Currency) Money {
    return .{ .value = amount, .currency = currency };
}

pub fn makeEuros(amount: i32) Money {
    return .{ .value = amount, .currency = Currency.EUR };
}

pub fn makeDollars(amount: i32) Money {
    return .{ .value = amount, .currency = Currency.USD };
}

pub fn format(
    money: Money,
    comptime _: []const u8,
    _: std.fmt.FormatOptions,
    writer: anytype,
) !void {
    try writer.print("{} {s}\n", .{ money.value, money.currency.toSymbol() });
}

test "can build money with helpers" {
    const one_eur = make(100, Currency.EUR);
    const one_eur_2 = makeEuros(100);
    try testing.expect(one_eur.currency == one_eur_2.currency);
    try testing.expect(one_eur.value == one_eur_2.value);
}

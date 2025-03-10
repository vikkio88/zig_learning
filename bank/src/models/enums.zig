const std = @import("std");
const eq = std.testing.expectEqual;

pub const Currency = enum {
    EUR,
    GBP,
    USD,

    pub fn format(self: Currency) []const u8 {
        return switch (self) {
            Currency.EUR => "{}€",
            Currency.GBP => "£{}",
            Currency.USD => "{}$",
        };
    }

    pub fn toSymbol(self: Currency) []const u8 {
        return switch (self) {
            Currency.EUR => "€",
            Currency.GBP => "£",
            Currency.USD => "$",
        };
    }
};

test "toSymbol" {
    try eq("$", Currency.USD.toSymbol());
    try eq("€", Currency.EUR.toSymbol());
    try eq("£", Currency.GBP.toSymbol());
}

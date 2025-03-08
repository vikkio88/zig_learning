const std = @import("std");

const models = @import("models/money.zig");
const enums = @import("models/enums.zig");
pub fn main() !void {
    const m = models.Money.make(300, enums.Currency.EUR);

    std.debug.print("{}", .{m});
}

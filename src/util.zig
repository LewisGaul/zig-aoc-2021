const std = @import("std");
const print = std.debug.print;
const ParseIntError = std.fmt.ParseIntError;

const Str = []const u8;

pub fn runPart(part: fn (Str) anyerror!u32, data: Str) !void {
    const start = std.time.nanoTimestamp();
    const answer = try part(data);
    const end = std.time.nanoTimestamp();
    print("Answer: {d}\n", .{answer});
    print(
        "Took: {d} s, {d} ms, {d} us, {d} ns\n",
        .{
            @intToFloat(f64, end - start) / 1_000_000_000,
            @intToFloat(f64, end - start) / 1_000_000,
            @intToFloat(f64, end - start) / 1_000,
            end - start,
        },
    );
}

pub const LineIter = struct {
    _iter: std.mem.SplitIterator(u8),

    const Self = @This();

    pub fn init(input: Str) Self {
        return .{ ._iter = std.mem.split(u8, input, "\n") };
    }

    pub fn next(self: *Self) ParseIntError!?u32 {
        if (self._iter.next()) |line| {
            const trimmed = std.mem.trim(u8, line, " \t\r");
            if (trimmed.len == 0) return try self.next();
            return try std.fmt.parseUnsigned(u32, trimmed, 10);
        } else {
            return null;
        }
    }
};

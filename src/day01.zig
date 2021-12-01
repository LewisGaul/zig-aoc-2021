const std = @import("std");
const print = std.debug.print;
const ParseIntError = std.fmt.ParseIntError;

const data = @embedFile("../data/day01.txt");

const Str = []const u8;

const LineIter = struct {
    _iter: std.mem.SplitIterator(u8),

    const Self = @This();

    pub fn init(input: Str) Self {
        return .{ ._iter = std.mem.split(u8, input, "\n") };
    }

    pub fn next(self: *Self) ParseIntError!?u32 {
        if (self._iter.next()) |line| {
            const trimmed = std.mem.trim(u8, line, " \n\r");
            if (trimmed.len == 0) return try self.next();
            return try std.fmt.parseUnsigned(u32, trimmed, 10);
        } else {
            return null;
        }
    }
};

fn mainFromData(input: Str) !u32 {
    var answer: u32 = 0;
    var iter = LineIter.init(input);
    var prev_num: ?u32 = try iter.next();
    while (try iter.next()) |num| {
        if (num > prev_num.?) answer += 1;
        prev_num = num;
    }
    return answer;
}

pub fn main() !void {
    print("Answer: {d}\n", .{try mainFromData(data)});
}

test {
    const input =
        \\123
        \\124
        \\  125
        \\100
        \\
        \\100
        \\20
        \\21
        \\
    ;
    try std.testing.expectEqual(@as(u32, 3), try mainFromData(input));
}

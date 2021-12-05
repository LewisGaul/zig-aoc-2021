const std = @import("std");
const print = std.debug.print;
const ParseIntError = std.fmt.ParseIntError;

const util = @import("util.zig");
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
            const trimmed = std.mem.trim(u8, line, " \t\r");
            if (trimmed.len == 0) return try self.next();
            return try std.fmt.parseUnsigned(u32, trimmed, 10);
        } else {
            return null;
        }
    }
};

fn part1(input: Str) !u32 {
    var answer: u32 = 0;
    var iter = LineIter.init(input);
    var prev_num: ?u32 = try iter.next();
    while (try iter.next()) |num| {
        if (num > prev_num.?) answer += 1;
        prev_num = num;
    }
    return answer;
}

fn part2(input: Str) !u32 {
    var answer: u32 = 0;
    var iter = LineIter.init(input);
    var num1: ?u32 = try iter.next();
    var num2: ?u32 = try iter.next();
    var num3: ?u32 = try iter.next();
    while (try iter.next()) |next_num| {
        if (next_num > num1.?) answer += 1;
        num1 = num2;
        num2 = num3;
        num3 = next_num;
    }
    return answer;
}

pub fn main() !void {
    try util.runPart(part1, data);
    print("\n", .{});
    try util.runPart(part2, data);
}

test "1a" {
    try std.testing.expectEqual(@as(u32, 0), try part1(""));
    try std.testing.expectEqual(@as(u32, 0), try part1("100"));
    try std.testing.expectEqual(@as(u32, 0), try part1("100\n99"));
    try std.testing.expectEqual(@as(u32, 0), try part1("100\n100"));
    try std.testing.expectEqual(@as(u32, 1), try part1("100\n101"));
    try std.testing.expectEqual(@as(u32, 2), try part1("100\n101\n102\n"));
    try std.testing.expectEqual(@as(u32, 1), try part1("  100  \n  101  "));
    try std.testing.expectError(error.InvalidCharacter, part1("text"));

    {
        const input =
            \\199
            \\200
            \\208
            \\210
            \\200
            \\207
            \\240
            \\269
            \\260
            \\263
        ;
        try std.testing.expectEqual(@as(u32, 7), try part1(input));
    }

    {
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
        try std.testing.expectEqual(@as(u32, 3), try part1(input));
    }
}

test "1b" {
    try std.testing.expectEqual(@as(u32, 0), try part2(""));
    try std.testing.expectEqual(@as(u32, 0), try part2("100"));
    try std.testing.expectEqual(@as(u32, 0), try part2("100\n101\n102"));
    try std.testing.expectEqual(@as(u32, 1), try part2("100\n101\n102\n103"));
    try std.testing.expectError(error.InvalidCharacter, part2("text"));

    const input =
        \\199
        \\200
        \\208
        \\210
        \\200
        \\207
        \\240
        \\269
        \\260
        \\263
    ;
    try std.testing.expectEqual(@as(u32, 5), try part2(input));
}

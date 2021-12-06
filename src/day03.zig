const std = @import("std");
const assert = std.debug.assert;
const print = std.debug.print;

const util = @import("util.zig");
const data = @embedFile("../data/day03.txt");

const Str = []const u8;

fn part1(input: Str) !u32 {
    const line_len = std.mem.indexOfScalar(u8, input, '\n').?;
    var bit_counts: []u16 = try util.gpa.alloc(u16, line_len);
    defer util.gpa.free(bit_counts);
    for (bit_counts) |*count| count.* = 0;

    var lines_iter = std.mem.split(u8, input, "\n");
    var num_lines: u16 = 0;
    while (lines_iter.next()) |line| {
        num_lines += 1;
        for (line) |ch, i| {
            switch (ch) {
                '1' => bit_counts[i] += 1,
                '0' => {},
                else => unreachable,
            }
        }
    }
    var gamma: u32 = 0;
    for (bit_counts) |count, i| {
        if (count > num_lines / 2) {
            gamma += @as(u32, 1) << @intCast(u5, line_len - 1 - i);
        }
    }
    const mask = (@as(u32, 1) << @intCast(u5, line_len)) - 1;
    const eps = ~gamma & mask;
    return gamma * eps;
}

fn part2(input: Str) !u32 {
    _ = input;
    return 0;
}

pub fn main() !void {
    try util.runPart(part1, data);
    print("\n", .{});
    try util.runPart(part2, data);
}

test "3a" {
    const input =
        \\00100
        \\11110
        \\10110
        \\10111
        \\10101
        \\01111
        \\00111
        \\11100
        \\10000
        \\11001
        \\00010
        \\01010
    ;
    try std.testing.expectEqual(@as(u32, 198), try part1(input));
}

// test "3b" {
//     const input =
//         \\00100
//         \\11110
//         \\10110
//         \\10111
//         \\10101
//         \\01111
//         \\00111
//         \\11100
//         \\10000
//         \\11001
//         \\00010
//         \\01010
//     ;
//     try std.testing.expectEqual(@as(u32, 900), try part2(input));
// }

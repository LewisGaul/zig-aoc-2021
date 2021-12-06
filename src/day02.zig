const std = @import("std");
const assert = std.debug.assert;
const print = std.debug.print;

const util = @import("util.zig");
const data = @embedFile("../data/day02.txt");

const Str = []const u8;

fn readLineNum(input: Str, idx: *usize) !u8 {
    var start_idx: ?usize = null;
    while (idx.* < input.len) : (idx.* += 1) {
        switch (input[idx.*]) {
            ' ' => {
                start_idx = idx.* + 1;
            },
            '\n' => break,
            else => continue,
        }
    }
    assert(start_idx != null);
    return std.fmt.parseUnsigned(u8, input[start_idx.?..idx.*], 10);
}

fn part1(input: Str) !u32 {
    var depth: u32 = 0; // assuming depth can't go negative
    var distance: u32 = 0;

    // Let's use a quicker parsing method, directly stepping through chars.
    var i: usize = 0;
    while (i < input.len) : (i += 1) {
        const direction: enum { Forward, Down, Up } = switch (input[i]) {
            'f' => .Forward,
            'd' => .Down,
            'u' => .Up,
            else => return error.UnexpectedChar,
        };
        const num = try readLineNum(input, &i);
        switch (direction) {
            .Forward => {
                distance += num;
            },
            .Down => {
                depth += num;
            },
            .Up => {
                depth -= num;
            },
        }
    }

    return depth * distance;
}

fn part2(input: Str) !u32 {
    var distance: u32 = 0;
    var aim: i32 = 0;
    var depth: i32 = 0;

    // Let's use a quicker parsing method, directly stepping through chars.
    var i: usize = 0;
    while (i < input.len) : (i += 1) {
        const direction: enum { Forward, Down, Up } = switch (input[i]) {
            'f' => .Forward,
            'd' => .Down,
            'u' => .Up,
            else => return error.UnexpectedChar,
        };
        const num = try readLineNum(input, &i);
        switch (direction) {
            .Forward => {
                distance += num;
                depth += aim * num;
            },
            .Down => {
                aim += num;
            },
            .Up => {
                aim -= num;
            },
        }
    }

    return @intCast(u32, depth) * distance;
}

pub fn main() !void {
    try util.runPart(part1, data);
    print("\n", .{});
    try util.runPart(part2, data);
}

test "2a" {
    const input =
        \\forward 5
        \\down 5
        \\forward 8
        \\up 3
        \\down 8
        \\forward 2
    ;
    try std.testing.expectEqual(@as(u32, 150), try part1(input));
}

test "2b" {
    const input =
        \\forward 5
        \\down 5
        \\forward 8
        \\up 3
        \\down 8
        \\forward 2
    ;
    try std.testing.expectEqual(@as(u32, 900), try part2(input));
}

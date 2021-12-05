const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;
const Str = []const u8;
const print = std.debug.print;

var gpa_impl = std.heap.GeneralPurposeAllocator(.{}){};
pub const gpa = &gpa_impl.allocator;

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

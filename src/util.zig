const std = @import("std");
const print = std.debug.print;

const Str = []const u8;

var gpa_impl = std.heap.GeneralPurposeAllocator(.{}){};
pub const gpa = &gpa_impl.allocator();

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

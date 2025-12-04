const std = @import("std");

const input_data = @embedFile("data.txt");

pub fn main() !void {
    std.debug.print("Input data:\n{s}\n", .{input_data});

    var lines = std.mem.splitScalar(u8, input_data, '\n');
    while (lines.next()) |line| {
        if (line.len == 0) continue;
        std.debug.print("Processing line: {s}\n", .{line});
    }
}

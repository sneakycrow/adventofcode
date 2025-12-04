const std = @import("std");

const input_data = @embedFile("data.txt");

pub fn main() !void {
    var lines = std.mem.splitScalar(u8, input_data, '\n');
    var index: usize = 1;
    while (lines.next()) |line| {
        if (line.len == 0) {
            index += 1;
            continue;
        } else {
            std.io.getStdOut().writer().print("{}: {s}\n", .{ index, line }) catch |err| switch (err) {
                error.BrokenPipe => return,
                else => return err,
            };
            index += 1;
        }
    }
}

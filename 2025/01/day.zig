const std = @import("std");

const build = @import("build");

pub fn main() !void {
    const input_file = build.input_file;
    std.debug.print("Reading from: {s}\n", .{input_file});
}

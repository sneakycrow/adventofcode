const std = @import("std");

const input_data = @embedFile("data.txt");

pub fn main() !void {
    var lines = std.mem.splitScalar(u8, input_data, '\n');

    var dial_position: isize = 50;
    var zero_positions: usize = 0;

    while (lines.next()) |line| {
        if (line.len == 0) {
            continue;
        } else {
            // Find out, based on the first character, if we're going up or down
            const dial_direction = line[0];
            const polarity: isize = if (dial_direction == 'R') 1 else if (dial_direction == 'L') -1 else return error.InvalidDirection;

            // Store the number we're going up or down by
            const number_str = line[1..];
            const number = try std.fmt.parseInt(isize, number_str, 10);

            // Adjust the dial position appropriately
            dial_position += polarity * number;

            // Wrap the dial position to stay within 0-99 range
            dial_position = @mod(dial_position, 100);
            if (dial_position < 0) {
                dial_position += 100;
            }

            if (dial_position == 0) {
                zero_positions += 1;
            }
        }
    }

    std.io.getStdOut().writer().print(
        "Zero count: {}\n",
        .{zero_positions},
    ) catch |err| switch (err) {
        error.BrokenPipe => return,
        else => return err,
    };
}

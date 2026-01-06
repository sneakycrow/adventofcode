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

            // Calculate how many times we encounter zero during this movement
            const old_position = dial_position;
            const movement = polarity * number;

            // Count zero encounters by simulating the movement step by step
            var current_pos = old_position;
            const step: isize = if (movement > 0) 1 else -1;
            var remaining_steps = @abs(movement);

            while (remaining_steps > 0) {
                current_pos += step;

                // Handle wrapping
                if (current_pos >= 100) {
                    current_pos = 0;
                } else if (current_pos < 0) {
                    current_pos = 99;
                }

                // Count if we hit zero
                if (current_pos == 0) {
                    zero_positions += 1;
                }

                remaining_steps -= 1;
            }

            // Update dial position to final position
            dial_position = current_pos;
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

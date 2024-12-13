const std = @import("std");

const input = @embedFile("data/01.txt");
pub fn main() !void {
    std.debug.print("Calculating answer for Advent of Code 2024 - Day 01\n", .{});
    std.debug.print("Using data embedded in binary\n", .{});
    // First setup an allocator
    // We don't know what the size of the file will be
    // We need an allocator to make sure we're not using too
    // much/little memory
    // gpa - general purpose allocator
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    // Deferred calls get called when we exit scope
    // So this will call gpa.deinit() when we exit scope, and we ignore the result using `_`
    defer _ = gpa.deinit();
    // This gives us the actual interface for us to do memory management
    // We'll use this to read the file into memory
    const allocator = gpa.allocator();

    // Parse the contents into two columns
    // Initialize empty columns
    var column1 = Column{ .numbers = std.ArrayList(i64).init(allocator) };
    var column2 = Column{ .numbers = std.ArrayList(i64).init(allocator) };
    defer column1.numbers.deinit();
    defer column2.numbers.deinit();
    // Split the content by each newline character
    var lines = std.mem.splitScalar(u8, input, '\n');
    // Loop through the lines to split the two columns
    while (lines.next()) |line| {
        if (line.len == 0) continue; // Skip empty lines
        // Split by whitespace (handles multiple spaces)
        var numbers = std.mem.tokenizeScalar(u8, line, ' ');

        // Get first number
        if (numbers.next()) |num1| {
            try column1.numbers.append(try std.fmt.parseInt(i64, num1, 10));
        }
        // Get second number
        if (numbers.next()) |num2| {
            try column2.numbers.append(try std.fmt.parseInt(i64, num2, 10));
        }
    }
    // Sort the columns
    std.sort.heap(i64, column1.numbers.items, {}, std.sort.asc(i64));
    std.sort.heap(i64, column2.numbers.items, {}, std.sort.asc(i64));
    // Loop through each "row" and calculate the difference between them
    // This assumes that each column is the same length
    var total_difference: u64 = 0;
    const len = column1.numbers.items.len;
    for (0..len) |i| {
        const diff = @abs(column2.numbers.items[i] - column1.numbers.items[i]);
        total_difference += diff;
    }
    std.debug.print("Answer: {d}\n", .{total_difference});
    std.debug.print("Also, fuck you Ian\n", .{});
}

/// getDataPath will construct the path and check if we have access
fn getDataPath(allocator: std.mem.Allocator, filename: []const u8) ![]const u8 {
    const path = try std.fs.path.join(allocator, &.{ "data", filename });

    // Try to access the file
    std.fs.cwd().access(path, .{}) catch |err| {
        allocator.free(path); // Clean up the allocated path
        return err; // Return the error (likely error.FileNotFound)
    };

    return path;
}

/// A column of numbers
const Column = struct { numbers: std.ArrayList(i64) };

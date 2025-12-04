const std = @import("std");

pub fn build(b: *std.Build) void {
    const targetDay = b.option([]const u8, "target_day", "The day of the target problem") orelse {
        std.log.err("Missing required option: -Dtarget_day=XX (e.g., -Dtarget_day=01)", .{});
        std.process.exit(1);
    };
    const inputFile = b.option([]const u8, "input_file", "The input file to read") orelse {
        std.log.err("Missing required option: -Dinput_file=filename (e.g., -Dinput_file=input.txt)", .{});
        std.process.exit(1);
    };

    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const exe = b.addExecutable(.{
        .name = "01",
        .root_module = b.createModule(.{
            .root_source_file = b.path(b.fmt("{s}/day.zig", .{targetDay})),
            .target = target,
            .optimize = optimize,
        }),
    });

    const options = b.addOptions();
    options.addOption([]const u8, "input_file", inputFile);
    exe.root_module.addOptions("build", options);

    b.installArtifact(exe);

    const run_exe = b.addRunArtifact(exe);

    const run_step = b.step("run", "Run the application");
    run_step.dependOn(&run_exe.step);
}

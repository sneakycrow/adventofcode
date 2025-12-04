const std = @import("std");

pub fn build(b: *std.Build) void {
    const targetDay = b.option([]const u8, "target_day", "The day of the target problem");

    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const exe = b.addExecutable(.{
        .name = "01",
        .root_module = b.createModule(.{
            .root_source_file = b.path(b.fmt("{s}/day.zig", .{targetDay.?})),
            .target = target,
            .optimize = optimize,
        }),
    });

    b.installArtifact(exe);

    const run_exe = b.addRunArtifact(exe);

    const run_step = b.step("run", "Run the application");
    run_step.dependOn(&run_exe.step);
}

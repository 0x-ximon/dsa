const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addModule("dsa", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });

    // const exe = b.addExecutable(.{
    //     .name = "dsa",
    //     .root_module = b.createModule(.{
    //         .root_source_file = b.path("src/main.zig"),
    //         .target = target,
    //         .optimize = optimize,
    //         .imports = &.{
    //             .{ .name = "lib", .module = lib },
    //         },
    //     }),
    // });

    const tests = b.addTest(.{
        .use_llvm = true,
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/test.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "lib", .module = lib },
            },
        }),
    });

    // b.installArtifact(exe);
    // const run_step = b.step("run", "Run the app");
    // const run_cmd = b.addRunArtifact(exe);

    // run_step.dependOn(&run_cmd.step);
    // run_cmd.step.dependOn(b.getInstallStep());
    // run_cmd.addPassthruArgs();

    const test_step = b.step("test", "Run tests");
    const run_tests = b.addRunArtifact(tests);
    test_step.dependOn(&run_tests.step);
}

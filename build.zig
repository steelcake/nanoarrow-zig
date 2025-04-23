const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const upstream = b.dependency("upstream", .{
        .target = target,
        .optimize = optimize,
    });

    const lib_mod = b.createModule(.{
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    });
    lib_mod.addCSourceFiles(.{
        .root = upstream.path("src/nanoarrow/common"),
        .files = &[_][]const u8 {
            "array.c",
            "schema.c",
            "array_stream.c",
            "utils.c",
        },
    });

    const lib = b.addLibrary(.{
        .linkage = .static,
        .name = "nanoarrow",
        .root_module = lib_mod,
    });

    lib.addIncludePath(upstream.path("src"));

    const config = b.addConfigHeader(.{
        .style = .{ .cmake = upstream.path("src/nanoarrow/nanoarrow_config.h.in") },
        .include_path = "nanoarrow/nanoarrow_config.h",
    }, .{
        .NANOARROW_VERSION_MAJOR = 0,
        .NANOARROW_VERSION_MINOR = 6,
        .NANOARROW_VERSION_PATCH = 0,
        .NANOARROW_VERSION = "0.6.0",
        .NANOARROW_NAMESPACE_DEFINE = "",
    });
    lib.addConfigHeader(config);
    lib.installHeader(upstream.path("src/nanoarrow/nanoarrow.h"), "nanoarrow/nanoarrow.h");
    lib.installHeader(upstream.path("src/nanoarrow/common/inline_array.h"), "nanoarrow/common/inline_array.h");
    lib.installHeader(upstream.path("src/nanoarrow/common/inline_buffer.h"), "nanoarrow/common/inline_buffer.h");
    lib.installHeader(upstream.path("src/nanoarrow/common/inline_types.h"), "nanoarrow/common/inline_types.h");

    b.installArtifact(lib);
}

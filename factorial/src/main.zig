const std = @import("std");
const Io = std.Io;

pub fn main(init: std.process.Init) !void {
    // This is appropriate for anything that lives as long as the process.
    const arena: std.mem.Allocator = init.arena.allocator();

    // Accessing command line arguments:
    const args = try init.minimal.args.toSlice(arena);

    const args_num = init.minimal.args.vector.len;

    if (args_num != 2) {
        std.debug.print("Incorrect arguments", .{});
        return;
    }

    const arg = args[1];

    const num = std.fmt.parseInt(u32, arg, 10) catch |err| {
        std.debug.print("Invalid argument {}", .{err});
        return;
    };

    try factorial(num, init);
}

pub fn factorial(num: u32, init: std.process.Init) !void {
    var i: u32 = num;
    var total: u128 = 1;

    var stdout_buffer: [1024]u8 = undefined;
    var stdout_file_writer: Io.File.Writer = .init(.stdout(), init.io, &stdout_buffer);
    const stdout_writer = &stdout_file_writer.interface;

    while (i > 0) {
        total *= i;
        try stdout_writer.print("{}", .{i});

        if (i != 1) {
            try stdout_writer.print(" X ", .{});
        } else {
            try stdout_writer.print(" = {}", .{total});
        }

        i -= 1;
    }

    try stdout_writer.print("\nFactorial: {}", .{total});

    try stdout_writer.flush();
}

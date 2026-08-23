const std = @import("std");
const Io = std.Io;

pub fn main(init: std.process.Init) !void {

    const arena: std.mem.Allocator = init.arena.allocator();

    const args = try init.minimal.args.toSlice(arena);
       
    if (args.len != 2) {
        std.debug.print("Incorrect number of arguments!", .{});
        return;
    }

    const num = std.fmt.parseInt(u32, args[1], 10) catch |err| {
        std.debug.print("Error parsing number {}", .{err});
        return;
    };

    var stdout_buffer: [1024]u8 = undefined;
    var stdout_file_writer: Io.File.Writer = .init(Io.File.stdout(), init.io, &stdout_buffer); 
    const stdout_writer = &stdout_file_writer.interface;

    if (isPrime(num)) {
        try stdout_writer.print("{} is prime.", .{num});
    } else {
        try stdout_writer.print("{} is not prime.", .{num});
    }

    try stdout_writer.flush();
}

pub fn isPrime(num: u32) bool {
    var half = num / 2;

    while (half > 1) {
        if (num % half == 0) {
            return false;
        }

        half -= 1;
    }

    return true;
}

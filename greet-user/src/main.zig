const std = @import("std");

const stdout = std.Io.File.stdout();
const stdin = std.Io.File.stdin();

pub fn main(init: std.process.Init) !void {
    // Buffered output
    var stdout_buffer: [64]u8 = undefined;
    var stdout_writer = stdin.writer(init.io, &stdout_buffer);
    const out: *std.Io.Writer = &stdout_writer.interface;

    try out.writeAll("Enter your name: ");
    try out.flush();

    // Buffered input
    var stdin_buffer: [64]u8 = undefined;
    var stdin_reader = stdin.reader(init.io, &stdin_buffer);
    const in: *std.Io.Reader = &stdin_reader.interface;

    const user_name = try in.takeDelimiter('\n') orelse unreachable;

    try out.print("Hello, {s}!", .{user_name});
    try out.flush();
}

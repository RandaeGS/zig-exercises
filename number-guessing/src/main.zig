const std = @import("std");
const Io = std.Io;

pub fn main(init: std.process.Init) !void {
    var out_buf: [1024]u8 = undefined;
    var stdout_writer = Io.File.writer(Io.File.stdout(), init.io, &out_buf);
    const output = &stdout_writer.interface;

    try output.print("Guess the number between 1 and 100: \n", .{});
    try output.flush();

    // Generating a secure random number in range
    const rng: std.Random.IoSource = .{ .io = init.io };
    const secureRand = rng.interface();
    const random_number = secureRand.intRangeAtMost(u16, 1, 100);

    var in_buf: [1024]u8 = undefined;
    var stdin_reader = Io.File.reader(Io.File.stdin(), init.io, &in_buf);
    const input = &stdin_reader.interface;

    var gameOver = false;
    while (!gameOver) {
        const user_number = try input.takeDelimiter('\n');
        const number = std.fmt.parseInt(u16, user_number.?, 10) catch |err| {
            std.debug.print("Error during integer parsing {}", .{err});
            return;
        };

        if (number < random_number) {
            try output.print("Number is higher. Try again!\n", .{});
            try output.flush();
        } else if (number > random_number) {
            try output.print("Number is lower. Try again!\n", .{});
            try output.flush();
        } else {
            gameOver = !gameOver;
        }
    }

    try output.print("You won, congratulations!", .{});
    try output.flush();
}

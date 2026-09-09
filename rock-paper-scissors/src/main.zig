const std = @import("std");
const Io = std.Io;

pub fn main(init: std.process.Init) !void {
    var out_buf: [1024]u8 = undefined;
    var stdout_writer = Io.File.writer(Io.File.stdout(), init.io, &out_buf);
    const output = &stdout_writer.interface;

    try output.print("Let's play a game\n", .{});
    try output.print("1.Rock 2.Paper 3.Scissors: \n", .{});
    try output.flush();

    var in_buf: [1024]u8 = undefined;
    var stdin_reader = Io.File.reader(Io.File.stdin(), init.io, &in_buf);
    const input = &stdin_reader.interface;

    var game_over = false;

    const rng: std.Random.IoSource = .{ .io = init.io };
    const secureRand = rng.interface();
    const computer_choice = secureRand.intRangeAtMost(u8, 1, 3);

    while (!game_over) {
        const user_choice = try input.takeDelimiter('\n');
        const number = std.fmt.parseInt(u8, user_choice.?, 10) catch |err| {
            std.debug.print("Error during integer parsing {}\n", .{err});
            return;
        };

        // Determine winner
        if (number == computer_choice) {
            try output.print("It's a tie!\n", .{});
        } else if ((number == 1 and computer_choice == 3) or
            (number == 2 and computer_choice == 1) or
            (number == 3 and computer_choice == 2))
        {
            try output.print("You win!\n", .{});
        } else {
            try output.print("You lose!\n", .{});
        }

        game_over = true;
    }

    try output.flush();
}

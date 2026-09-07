const std = @import("std");
const Io = std.Io;
const stdin = std.Io.File.stdin();

pub fn main(init: std.process.Init) !void {

    // In order to do I/O operations need an `Io` instance.
    const io = init.io;

    // Declaring input
    var input_buffer: [1024]u8 = undefined;
    var input_reader = Io.File.reader(stdin, io, &input_buffer);
    const input = &input_reader.interface;

    // Declaring standard output
    var stdout_buffer: [1024]u8 = undefined;
    var stdout_file_writer: Io.File.Writer = .init(.stdout(), io, &stdout_buffer);
    const stdout_writer = &stdout_file_writer.interface;

    try stdout_writer.print("Enter the word: ", .{});
    try stdout_writer.flush();

    const word = try input.takeDelimiter('\n');

    // .? unwraps optional ?[]u8 value, crashes if EOF is reached. Test with Ctrl+d in terminal.
    if (isPalindrome(word.?)) {
        try stdout_writer.print("The word is palindrome!", .{});
    } else {
        try stdout_writer.print("The word is not palindrome!", .{});
    }

    try stdout_writer.flush();
}

fn isPalindrome(word: []u8) bool {
    var i: usize = 0;
    var j = word.len - 1;

    while (i < j) {

        if (word[i] != word[j]) {
            return false;
        }

        i = i + 1;
        j = j - 1;
    }

    return true;
}

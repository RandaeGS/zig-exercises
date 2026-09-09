const std = @import("std");
const Io = std.Io;
const stdin = Io.File.stdin();
const stdout = Io.File.stdout();

pub fn main(init: std.process.Init) !void {
    var out_buf: [1024]u8 = undefined;
    var out_file = Io.File.writer(stdout, init.io, &out_buf);
    const output = &out_file.interface;

    var in_buf: [1024]u8 = undefined;
    var in_file = Io.File.reader(stdin, init.io, &in_buf);
    const input = &in_file.interface;

    try output.print("Enter the word: ", .{});
    try output.flush();

    const word = try input.takeDelimiter('\n');

    const vowel_count = count_vowels(word.?);
    try output.print("Vowel count is: {}", .{vowel_count});
    try output.flush();
}

fn count_vowels(word: []u8) u32 {
    var count: u32 = 0;

    for (word) |character| {
        switch (character) {
            'A', 'a', 'E', 'e', 'I', 'i', 'O', 'o', 'U', 'u' => {
                count = count + 1;
            },
            else => {},
        }
    }

    return count;
}

const std = @import("std");
const Io = std.Io;

pub fn main(init: std.process.Init) !void {
    const io = init.io;

    var in_buf: [512]u8 = undefined;
    var file_reader = Io.File.reader(Io.File.stdin(), io, &in_buf);
    const input = &file_reader.interface;

    var out_buf: [512]u8 = undefined;
    var file_writer = Io.File.writer(Io.File.stdout(), io, &out_buf);
    var output = &file_writer.interface;

    try output.print("Enter the temperature in farenheit: ", .{});
    try output.flush();

    var farenheit: f32 = undefined;
    const aux = try input.takeDelimiter('\n');
    farenheit = std.fmt.parseFloat(f32, aux.?) catch |err| {
        std.debug.print("Error parsing float {}", .{err});
        return;
    };

    // 5.0 must be specified or integer division will be evaluated first, resulting in 0.
    const celcius: f32 =   5.0 / 9.0 * ( farenheit - 32.0 );
    const kelvin: f32 = celcius + 273.15;

    try output.print("Celsius: {d:.2}\n", .{celcius});
    try output.print("Kelvin: {d:.2}", .{kelvin});

    try output.flush();
}

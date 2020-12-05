const std = @import("std");
const Allocator = std.mem.Allocator;
const assert = std.debug.assert;
const print = std.debug.print;

const input = @embedFile("../in05.txt");

const SeatedArray = std.PackedIntArray(u1, 2048);

pub fn main() !void {
    var min_seatid: u16 = 256;
    var max_seatid: u16 = 0;
    var seated = SeatedArray.init(std.mem.zeroes([2048]u1));

    var line_it = std.mem.tokenize(input, "\n");
    while (line_it.next()) |line| {
        var row: u16 = 0;
        // couldn't get the casting on this to work:
        //for (line[0..7]) |c, i| {
        //    var val: usize = if (c == 'B') 1 else 0;
        //    row |= val << (7 - i);
        //}
        if (line[0] == 'B') row |= 64;
        if (line[1] == 'B') row |= 32;
        if (line[2] == 'B') row |= 16;
        if (line[3] == 'B') row |= 8;
        if (line[4] == 'B') row |= 4;
        if (line[5] == 'B') row |= 2;
        if (line[6] == 'B') row |= 1;

        var col: u16 = 0;
        if (line[7] == 'R') col |= 4;
        if (line[8] == 'R') col |= 2;
        if (line[9] == 'R') col |= 1;

        var seatid: u16 = row * 8 + col;
        seated.set(seatid, 1);
        print("pass {} means row {}, seat {} seatid {}\n", .{ line, row, col, seatid });
        if (seatid > max_seatid) max_seatid = seatid;
        if (seatid < min_seatid) min_seatid = seatid;
    }

    print("Highest seatid is {}\n", .{max_seatid});

    var i: u16 = min_seatid + 1;
    while (i < max_seatid) {
        if (seated.get(i) != 1) {
            print("Missing seat is {}\n", .{i});
            break;
        }
        i += 1;
    } else {
        print("no missing seat found!", .{});
    }
}

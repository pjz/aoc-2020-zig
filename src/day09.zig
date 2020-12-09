const std = @import("std");
const Allocator = std.mem.Allocator;
const assert = std.debug.assert;
const print = std.debug.print;

const input = @embedFile("../in09.txt");

var xmas: [2048]usize = undefined;
var xmas_len: usize = 0;

fn load() !void {
    var line_it = std.mem.tokenize(input, "\n");
    xmas_len = 0;
    while (line_it.next()) |line| {
        xmas[xmas_len] = try std.fmt.parseInt(usize, line, 10);
        xmas_len += 1;
    }
}

pub fn main() !void {
    try load();

    var objective: usize = part1: {
        var sumi: usize = 26;
        var sum = xmas[sumi];
        while (sumi < xmas_len) {
            sum = xmas[sumi];
            var found = search: {
                var starti = sumi - 25;
                for (xmas[starti .. sumi - 1]) |a, i| {
                    for (xmas[starti + i + 1 .. sumi]) |b, j| {
                        if (a + b == sum) {
                            print("{} is {} + {}\n", .{ sum, a, b });
                            break :search true;
                        }
                    }
                }
                break :search false;
            };
            if (!found) {
                break :part1 sum;
            }
            sumi += 1;
        }
        break :part1 0;
    };
    print("{} isn't made up of two numbers in the list\n", .{objective});

    // now find run of at least 3 numbers that add up to sum

    var starti: usize = 0;

    while (starti < xmas_len - 2) {
        var sum = xmas[starti];
        var min = xmas[starti];
        var max = xmas[starti];
        var i = starti + 1;
        for (xmas[starti + 1 .. xmas_len]) |n| {
            if (n < min) min = n;
            if (n > max) max = n;
            sum += n;
            if (sum >= objective) break;
        }
        if (sum == objective) {
            print("Found weakness {}\n", .{min + max});
            break;
        }
        starti += 1;
    }
}

const std = @import("std");
const Allocator = std.mem.Allocator;
const assert = std.debug.assert;
const print = std.debug.print;

const maptxt = @embedFile("../in03.txt");

fn width(comptime input: []const u8) usize {
    var i: usize = 0;
    while (i < input.len) : (i += 1) {
        if (input[i] == '\n') return i;
    }
    return i;
}

const mapwidth = width(maptxt);
const linelength = mapwidth + 1;

fn length(comptime input: []const u8) usize {
    return input.len / (width(input) + 1);
}

const maplength = length(maptxt);

const map = @ptrCast(*const [maplength][linelength]u8, &map);

fn cast_atpos(x: usize, y: usize) u8 {
    print("finding char at ({}, {})\n", .{ x, y });
    return map[y][x % linelength];
}

fn math_atpos(x: usize, y: usize) u8 {
    var i = (y * linelength) + (x % mapwidth);
    if (i >= map.len) {
        print("map is only {}\n", .{map.len});
        assert(i < map.len);
    }
    //print("turned ({}, {}) into {} -> {c}\n", .{ x, y, i, maptxt[i] });
    return maptxt[i];
}

var atpos = cast_atpos;

fn count_trees(dx: usize, dy: usize) usize {
    var trees: usize = 0;
    var x: usize = 0;
    var y: usize = 0;
    while (y < maplength) : (y += dy) {
        if (atpos(x, y) == '#') trees += 1;
        x += dx;
    }
    print("Found {} trees at slope ({}, {})\n", .{ trees, dx, dy });
    return trees;
}

pub fn main() !void {
    print("Map is {}x{}\n", .{ mapwidth, maplength });
    var answer = count_trees(1, 1) *
        count_trees(3, 1) *
        count_trees(5, 1) *
        count_trees(7, 1) *
        count_trees(1, 2);
    print("for an answer of {}\n", .{answer});
}

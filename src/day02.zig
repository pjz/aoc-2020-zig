const std = @import("std");
const Allocator = std.mem.Allocator;
const assert = std.debug.assert;
const print = std.debug.print;

const input = @embedFile("../in02.txt");

pub fn main() !void {
    var inputit = std.mem.tokenize(input, "\n");

    var valids: usize = 0;
    while (inputit.next()) |line| {
        var lineit = std.mem.tokenize(line, " -:");
        var minlets = lineit.next() orelse @panic("no minlet");
        var minleti = try std.fmt.parseInt(usize, minlets, 10);
        var maxlets = lineit.next() orelse @panic("no maxlet");
        var maxleti = try std.fmt.parseInt(usize, maxlets, 10);
        var let = lineit.next() orelse @panic("no letter");
        var password = lineit.next() orelse @panic("no password");

        var count: usize = 0;
        for (password) |c| {
            if (let[0] == c) count += 1;
        }
        if (count < minleti) continue;
        if (count > maxleti) continue;
        valids += 1;
    }
    print("Found {} valid passwords according to the old rules\n", .{valids});

    inputit = std.mem.tokenize(input, "\n");
    var newvalids: usize = 0;
    while (inputit.next()) |line| {
        var lineit = std.mem.tokenize(line, " -:");
        var minlets = lineit.next() orelse @panic("no minlet");
        var minleti = try std.fmt.parseInt(usize, minlets, 10);
        var maxlets = lineit.next() orelse @panic("no maxlet");
        var maxleti = try std.fmt.parseInt(usize, maxlets, 10);
        var let = lineit.next() orelse @panic("no letter");
        var password = lineit.next() orelse @panic("no password");

        var count: usize = 0;
        if (password.len >= minleti and password[minleti - 1] == let[0]) count += 1;
        if (password.len >= maxleti and password[maxleti - 1] == let[0]) count += 1;
        print("found {} occurances of {c} between positions {} and {} in {}\n", .{ count, let[0], minleti, maxleti, password });
        if (count != 1) continue;
        newvalids += 1;
        print("that makes {}\n", .{newvalids});
    }
    print("Found {} valid passwords according to the new rules\n", .{newvalids});
}

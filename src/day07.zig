const std = @import("std");
const Allocator = std.mem.Allocator;
const assert = std.debug.assert;
const print = std.debug.print;

const input = @embedFile("../in07.txt");

fn find_bag_def(bag: []const u8) []const u8 {
    var line_it = std.mem.tokenize(input, "\n");
    while (line_it.next()) |line| {
        if (std.mem.startsWith(u8, line, bag)) {
            return line;
        }
    }
    print("No bag matching '{}' found!", .{bag});
    @panic("unknown bag!");
}

fn contains_shiny(bag: []const u8) bool {
    //print(" {} -", .{bag});
    if (std.mem.eql(u8, bag, "shiny gold")) return true;
    if (std.mem.eql(u8, bag, "no other")) return false;
    var bag_def_line = find_bag_def(bag);
    var eocontains: usize = std.mem.indexOf(u8, bag_def_line, "contain") orelse @panic("uncontaining bag");
    eocontains += 8; // length of "contain "
    var baglist = bag_def_line[eocontains..];
    var bag_it = std.mem.split(baglist, ",");
    while (bag_it.next()) |numbags| {
        var bag_name = std.mem.trimLeft(u8, numbags, " 1234567890");
        var eoname = std.mem.indexOf(u8, bag_name, " bag") orelse @panic("not a bag");
        bag_name = bag_name[0..eoname];
        if (contains_shiny(bag_name)) return true;
    }
    return false;
}

fn weight_of(bag: []const u8) usize {
    var weight: usize = 0;
    if (std.mem.eql(u8, bag, "no other")) return weight;
    weight += 1; // self weight
    var bag_def_line = find_bag_def(bag);
    var eocontains: usize = std.mem.indexOf(u8, bag_def_line, "contain") orelse @panic("uncontaining bag");
    eocontains += 8; // length of "contain "
    var baglist = bag_def_line[eocontains..];
    var bag_it = std.mem.split(baglist, ",");
    while (bag_it.next()) |numbags| {
        var bag_name = std.mem.trimLeft(u8, numbags, " ");
        var eonum = std.mem.indexOf(u8, bag_name, " ") orelse @panic("not a bag");
        var num = std.fmt.parseInt(usize, bag_name[0..eonum], 10) catch 0;
        if (num == 0) {
            //print("couldn't parse {} - got number {}\n", .{ numbags, bag_name[0 .. eonum - 1] });
            continue; // "no other bags" fails to barse a number
        }
        var eoname = std.mem.indexOf(u8, bag_name, " bag") orelse @panic("not a bag");
        bag_name = bag_name[eonum + 1 .. eoname];
        weight += num * weight_of(bag_name);
    }
    return weight;
}

pub fn main() !void {
    if (false) {
        var line_it = std.mem.tokenize(input, "\n");
        var count: usize = 0;
        while (line_it.next()) |line| {
            var word_it = std.mem.split(line, " bag");
            if (word_it.next()) |bag| {
                //print("{}: Checking {} :", .{ count, bag });
                if (contains_shiny(bag)) count += 1;
                ////print("\n", .{});
            }
        }
        count -= 1; // the shiny gold bag can't hold itself
        print("{} bags can be outside a shiny gold one.\n", .{count});
    }
    {
        var weight = weight_of("shiny gold");
        weight -= 1; // the shiny gold bag can't hold itself
        print("shiny gold bag contains {} bags\n", .{weight});
    }
}

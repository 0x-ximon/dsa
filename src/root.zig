const std = @import("std");
const testing = std.testing;

pub const LinkedList = @import("structures/linked_list.zig");
pub const HashSet = @import("structures/hash_set.zig");
pub const HashMap = @import("structures/hash_map.zig");

test "basic add functionality" {
    testing.refAllDecls(LinkedList);
    testing.refAllDecls(HashSet);
    testing.refAllDecls(HashMap);
}

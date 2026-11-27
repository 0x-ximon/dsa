const std = @import("std");
const testing = std.testing;

pub const HashMap = @import("structures/hash_map.zig");
pub const HashSet = @import("structures/hash_set.zig");
pub const LinkedList = @import("structures/linked_list.zig");
pub const Stack = @import("structures/stack.zig");

test "Entrypoint" {
    testing.refAllDecls(HashMap);
    testing.refAllDecls(HashSet);
    testing.refAllDecls(LinkedList);
    testing.refAllDecls(Stack);
}

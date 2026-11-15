const std = @import("std");
const mem = std.mem;
const math = std.math;
const testing = std.testing;

pub fn Compare(comptime T: type) type {
    return fn (a: T, b: T) math.Order;
}

/// A Sorted Map backed by a B+ Tree.
///
/// `K` & `V` are the key and value types, `M` is the minimum M-way factor.
/// `compare` is the comparison function for keys.
///
/// This map does not handle memory cleanup for keys or values but only nodes.
pub fn Map(comptime K: type, comptime V: type, comptime M: usize, comptime compare: Compare(K)) type {
    // Assuming M = 4
    const min_keys = M - 1; // 3
    const max_keys = (2 * M) - 1; // 7
    const min_children = M; // 4
    const max_children = (2 * M); // 8

    const Direction = enum { ascending, descending };

    return struct {
        const Self = @This();
        const KV = struct { key: K, value: V };

        root: ?*Node,
        size: u64,

        /// Initializes the Map
        pub fn init() Self {
            return .{ .root = null, .size = 0 };
        }

        /// Cleans up all Map Nodes but does not clean up Keys or Values.
        pub fn deinit(self: *Self, allocator: mem.Allocator) void {
            const root = self.root orelse return;

            var queue = std.ArrayList(*Node).empty;
            defer queue.deinit(allocator);

            var i: usize = 0;
            queue.append(allocator, root) catch return;
            while (i < queue.items.len) : (i += 1) {
                const node = queue.items[i];

                switch (node.*) {
                    .leaf => allocator.destroy(node),
                    .inner => |*inner| {
                        for (0..inner.count + 1) |j| {
                            if (inner.children[j]) |child| queue.append(allocator, child) catch continue;
                        }

                        allocator.destroy(node);
                    },
                }
            }
        }

        /// Returns the value associated with the given key, if it exists.
        pub fn get(self: *Self, key: K) ?V {
            if (self.root == null) return null;
            const entry = self.root.?.search(key);

            if (entry == null) return null;
            return entry.?.value;
        }

        /// Inserts or updates the value associated with the given key.
        pub fn put(self: *Self, allocator: mem.Allocator, key: K, value: V) !void {
            var root = self.root orelse {
                const node = try allocator.create(Node);
                node.* = .{ .leaf = .{ .count = 1, .next = null } };
                node.leaf.entries[0] = .{ .key = key, .value = value };
                self.root = node;
                self.size = 1;
                return;
            };

            if (root.full()) {
                const node = try allocator.create(Node);
                node.* = .{ .inner = .{ .count = 0 } };
                node.inner.children[0] = root;

                try node.split(allocator, root, 0);
                self.root = node;
                root = node;
            }

            const inserted = try root.insert(allocator, key, value);
            if (inserted) self.size += 1;
        }

        /// Removes the value associated with the given key, if it exists.
        pub fn rid(self: *Self, allocator: mem.Allocator, key: K) !bool {
            const root = self.root orelse return false;

            const deleted = try root.delete(allocator, key);
            if (!deleted) return false;
            self.size -= 1;

            if (root.empty()) {
                switch (root.*) {
                    .leaf => {
                        allocator.destroy(root);
                        self.root = null;
                        self.size = 0;
                    },
                    .inner => |*inner| {
                        const node = inner.children[0] orelse unreachable;
                        allocator.destroy(root);
                        self.root = node;
                    },
                }
            }

            return true;
        }

        /// Returns whether the map contains the given key.
        pub fn has(self: Self, key: K) bool {
            if (self.root == null) return false;
            return self.root.?.search(key) != null;
        }

        /// Returns the number of entries in the map.
        pub fn count(self: Self) u64 {
            return self.size;
        }

        /// Returns an iterator over the map's entries.
        pub fn iter(self: *Self, direction: Direction) Iterator {
            switch (direction) {
                .ascending => {
                    const node = self.head();
                    return .{ .node = node, .index = 0 };
                },
                .descending => {
                    const node = self.tail();
                    return .{ .node = node, .index = if (node) |n| n.leaf.count else 0 };
                },
            }
        }

        // Returns the first node in the map, or null if the map is empty.
        fn head(self: *Self) ?*Node {
            if (self.root) |root| {
                var node: *Node = root;
                while (node.* == .inner) node = node.inner.children[0] orelse unreachable;
                return node;
            }

            return null;
        }

        // Returns the last node in the map, or null if the map is empty.
        fn tail(self: *Self) ?*Node {
            if (self.root) |root| {
                var node: *Node = root;
                while (node.* == .inner) node = node.inner.children[node.inner.count] orelse unreachable;
                return node;
            }

            return null;
        }

        const Node = union((enum { inner, leaf })) {
            inner: Inner,
            leaf: Leaf,

            const Inner = struct {
                count: usize = 0, // current number of keys
                keys: [max_keys]K = undefined,
                children: [max_children]?*Node = @splat(null),
            };

            const Leaf = struct {
                count: usize = 0, // current number of entries
                prev: ?*Node = null,
                next: ?*Node = null,
                entries: [max_keys]KV = undefined,
            };

            fn search(self: *Node, key: K) ?KV {
                switch (self.*) {
                    .inner => |*node| {
                        var i: usize = 0;
                        while (i < node.count) : (i += 1) {
                            switch (compare(key, node.keys[i])) {
                                .gt, .eq => continue,
                                .lt => break,
                            }
                        }

                        const child = node.children[i] orelse unreachable;
                        return child.search(key);
                    },

                    .leaf => |*node| {
                        for (0..node.count) |i| {
                            switch (compare(key, node.entries[i].key)) {
                                .gt => continue,
                                .lt => break,
                                .eq => return node.entries[i],
                            }
                        }

                        return null;
                    },
                }
            }

            fn insert(self: *Node, allocator: mem.Allocator, key: K, value: V) !bool {
                switch (self.*) {
                    .leaf => |*node| {
                        var i: usize = 0;
                        while (i < node.count) : (i += 1) {
                            switch (compare(key, node.entries[i].key)) {
                                .gt => continue,
                                .lt => break,
                                .eq => {
                                    node.entries[i].value = value;
                                    return false;
                                },
                            }
                        }

                        var j = node.count;
                        while (j > i) : (j -= 1) node.entries[j] = node.entries[j - 1];
                        node.entries[i] = .{ .key = key, .value = value };
                        node.count += 1;
                        return true;
                    },

                    .inner => |*node| {
                        var i: usize = 0;
                        while (i < node.count) : (i += 1) {
                            switch (compare(key, node.keys[i])) {
                                .gt, .eq => continue,
                                .lt => break,
                            }
                        }

                        var child = node.children[i] orelse unreachable;
                        if (child.full()) {
                            try self.split(allocator, child, i);
                            switch (compare(key, node.keys[i])) {
                                .gt, .eq => {
                                    i += 1;
                                    child = node.children[i] orelse unreachable;
                                },
                                .lt => {},
                            }
                        }
                        return try child.insert(allocator, key, value);
                    },
                }
            }

            fn delete(self: *Node, allocator: mem.Allocator, key: K) !bool {
                switch (self.*) {
                    .leaf => |*node| {
                        for (0..node.count) |i| {
                            switch (compare(key, node.entries[i].key)) {
                                .gt => continue,
                                .lt => break,
                                .eq => {
                                    for (i..node.count - 1) |j| node.entries[j] = node.entries[j + 1];
                                    node.count -= 1;
                                    return true;
                                },
                            }
                        }

                        return false;
                    },
                    .inner => |*node| {
                        var i: usize = 0;
                        while (i < node.count) : (i += 1) {
                            switch (compare(key, node.keys[i])) {
                                .gt, .eq => continue,
                                .lt => break,
                            }
                        }

                        var child = node.children[i] orelse unreachable;
                        const deleted = try child.delete(allocator, key);
                        if (!deleted) return false;

                        if (child.underfull()) {
                            const left = if (i == 0) null else node.children[i - 1];
                            const right = if (i >= node.count) null else node.children[i + 1];
                            try self.move(allocator, child, left, right, i);
                        }

                        return true;
                    },
                }
            }

            fn split(self: *Node, allocator: mem.Allocator, child: *Node, index: usize) !void {
                const other = try allocator.create(Node);

                switch (child.*) {
                    .leaf => |*node| {
                        // Child gets 4, Other gets 3, First of Other gets promoted to self
                        other.* = .{ .leaf = .{ .count = min_keys, .prev = child, .next = node.next } };
                        @memcpy(other.leaf.entries[0..min_keys], node.entries[M..max_keys]);

                        // Whatever used to follow `child` now follows `other` instead.
                        if (other.leaf.next) |next_node| next_node.leaf.prev = other;

                        node.count = M;
                        node.next = other;

                        var i = self.inner.count;
                        while (i > index) : (i -= 1) {
                            self.inner.keys[i] = self.inner.keys[i - 1];
                            self.inner.children[i + 1] = self.inner.children[i];
                        }

                        self.inner.keys[i] = other.leaf.entries[0].key;
                        self.inner.children[i + 1] = other;
                        self.inner.count += 1;
                    },

                    .inner => {
                        // Child gets 3, Other gets 3, Middle gets promoted to self
                        other.* = .{ .inner = .{ .count = min_keys } };
                        @memcpy(other.inner.keys[0..min_keys], child.inner.keys[M..max_keys]);
                        @memcpy(other.inner.children[0..min_children], child.inner.children[min_children..max_children]);

                        child.inner.count = min_keys;

                        var i = self.inner.count;
                        while (i > index) : (i -= 1) {
                            self.inner.keys[i] = self.inner.keys[i - 1];
                            self.inner.children[i + 1] = self.inner.children[i];
                        }

                        // The key is still in the child, but it's no longer counted as child
                        self.inner.keys[i] = child.inner.keys[M - 1];
                        self.inner.children[i + 1] = other;
                        self.inner.count += 1;
                    },
                }
            }

            fn move(self: *Node, allocator: mem.Allocator, child: *Node, left: ?*Node, right: ?*Node, index: usize) !void {
                // Borrow from left if possible
                if (left) |other| {
                    if (!other.underfull()) {
                        switch (child.*) {
                            .leaf => |*node| {
                                var i = node.count;
                                const last = other.leaf.entries[other.leaf.count - 1];
                                while (i > 0) : (i -= 1) node.entries[i] = node.entries[i - 1];

                                node.entries[0] = last;
                                node.count += 1;
                                other.leaf.count -= 1;

                                self.inner.keys[index - 1] = node.entries[0].key;
                            },

                            .inner => |*node| {
                                var i = node.count;
                                while (i > 0) : (i -= 1) node.keys[i] = node.keys[i - 1];
                                node.keys[0] = self.inner.keys[index - 1];

                                const last = other.inner.keys[other.inner.count - 1];
                                self.inner.keys[index - 1] = last;

                                var j = node.count + 1;
                                while (j > 0) : (j -= 1) node.children[j] = node.children[j - 1];
                                node.children[0] = other.inner.children[other.inner.count];
                                other.inner.children[other.inner.count] = null;

                                node.count += 1;
                                other.inner.count -= 1;
                            },
                        }

                        return;
                    }
                }

                // Borrow from right if possible
                if (right) |other| {
                    if (!other.underfull()) {
                        switch (child.*) {
                            .inner => |*node| {
                                node.keys[node.count] = self.inner.keys[index];
                                node.children[node.count + 1] = other.inner.children[0];
                                self.inner.keys[index] = other.inner.keys[0];

                                for (1..other.inner.count) |i| other.inner.keys[i - 1] = other.inner.keys[i];
                                for (1..other.inner.count + 1) |i| other.inner.children[i - 1] = other.inner.children[i];
                                other.inner.children[other.inner.count] = null;

                                node.count += 1;
                                other.inner.count -= 1;
                            },
                            .leaf => |*node| {
                                const first = other.leaf.entries[0];
                                for (1..other.leaf.count) |i| other.leaf.entries[i - 1] = other.leaf.entries[i];
                                node.entries[node.count] = first;

                                node.count += 1;
                                other.leaf.count -= 1;

                                self.inner.keys[index] = other.leaf.entries[0].key;
                            },
                        }

                        return;
                    }
                }

                // Merge with left if possible
                if (left) |other| {
                    switch (child.*) {
                        .inner => |*node| {
                            other.inner.keys[other.inner.count] = self.inner.keys[index - 1];
                            other.inner.count += 1;

                            const start = other.inner.count;
                            const stop = start + node.count;
                            @memcpy(other.inner.keys[start..stop], node.keys[0..node.count]);
                            @memcpy(other.inner.children[start .. stop + 1], node.children[0 .. node.count + 1]);

                            other.inner.count += node.count;
                        },
                        .leaf => |*node| {
                            const start = other.leaf.count;
                            const stop = start + node.count;
                            @memcpy(other.leaf.entries[start..stop], node.entries[0..node.count]);

                            other.leaf.count += node.count;
                            other.leaf.next = node.next;

                            if (other.leaf.next) |next_node| next_node.leaf.prev = other;
                        },
                    }

                    for (index - 1..self.inner.count - 1) |i| self.inner.keys[i] = self.inner.keys[i + 1];
                    for (index..self.inner.count) |i| self.inner.children[i] = self.inner.children[i + 1];

                    self.inner.children[self.inner.count] = null;
                    self.inner.count -= 1;

                    allocator.destroy(child);
                    return;
                }

                // Merge with right if possible
                if (right) |other| {
                    switch (child.*) {
                        .inner => |*node| {
                            node.keys[node.count] = self.inner.keys[index];
                            node.count += 1;

                            const start = node.count;
                            const stop = start + other.inner.count;
                            @memcpy(node.keys[start..stop], other.inner.keys[0..other.inner.count]);
                            @memcpy(node.children[start .. stop + 1], other.inner.children[0 .. other.inner.count + 1]);

                            node.count += other.inner.count;
                        },
                        .leaf => |*node| {
                            const start = node.count;
                            const stop = node.count + other.leaf.count;
                            @memcpy(node.entries[start..stop], other.leaf.entries[0..other.leaf.count]);

                            node.count += other.leaf.count;
                            node.next = other.leaf.next;

                            if (node.next) |next_node| next_node.leaf.prev = child;
                        },
                    }

                    for (index..self.inner.count - 1) |i| self.inner.keys[i] = self.inner.keys[i + 1];
                    for (index + 1..self.inner.count) |i| self.inner.children[i] = self.inner.children[i + 1];

                    self.inner.children[self.inner.count] = null;
                    self.inner.count -= 1;

                    allocator.destroy(other);
                    return;
                }

                unreachable; // This should never happen
            }

            fn full(self: *Node) bool {
                return switch (self.*) {
                    .inner => |*node| node.count == max_keys,
                    .leaf => |*node| node.count == max_keys,
                };
            }

            fn underfull(self: *Node) bool {
                return switch (self.*) {
                    .inner => |*node| node.count <= min_keys,
                    .leaf => |*node| node.count <= min_keys,
                };
            }

            fn empty(self: *Node) bool {
                return switch (self.*) {
                    .inner => |*node| node.count == 0,
                    .leaf => |*node| node.count == 0,
                };
            }
        };

        const Iterator = struct {
            index: usize,
            node: ?*Node,

            pub fn next(self: *Iterator) ?KV {
                if (self.node) |node| {
                    switch (node.*) {
                        .inner => unreachable,
                        .leaf => |leaf| {
                            if (self.index < leaf.count) {
                                const entry = leaf.entries[self.index];
                                self.index += 1;
                                return entry;
                            }

                            if (leaf.next) |next_node| {
                                const entry = next_node.leaf.entries[0];
                                self.node = next_node;
                                self.index = 1;
                                return entry;
                            }

                            self.node = null;
                            self.index = 0;
                            return null;
                        },
                    }
                }

                return null;
            }

            pub fn prev(self: *Iterator) ?KV {
                if (self.node) |node| {
                    switch (node.*) {
                        .inner => unreachable,
                        .leaf => |leaf| {
                            if (self.index > 0) {
                                self.index -= 1;
                                return leaf.entries[self.index];
                            }

                            if (leaf.prev) |prev_node| {
                                self.node = prev_node;
                                self.index = prev_node.leaf.count - 1;
                                return prev_node.leaf.entries[self.index];
                            }

                            self.node = null;
                            self.index = 0;
                            return null;
                        },
                    }
                }

                return null;
            }
        };
    };
}

const Context = struct {
    const Self = @This();

    const K: type = u16;
    const V: type = u32;
    const M: usize = 8;

    const T: type = Map(K, V, M, compare);
    const E: type = T.KV;

    const Errors = error{
        AllocationFailed,
        ViolatedKeyInvariant,
        ViolatedOrderInvariant,
        ViolatedNullInvariant,
        ViolatedDepthInvariant,
        ViolatedLinkInvariant,
    };

    fn compare(a: K, b: K) math.Order {
        return math.order(a, b);
    }

    fn nodesInvariantsHold(allocator: mem.Allocator, map: *T) Errors!void {
        // Traverse the tree from the root via BFS
        const root = map.root orelse return;
        var deepest: ?usize = null;

        const Pair = struct {
            node: *T.Node,
            depth: usize,
        };

        var queue = std.ArrayList(Pair).empty;
        defer queue.deinit(allocator);

        var i: usize = 0;
        queue.append(allocator, Pair{
            .node = root,
            .depth = 0,
        }) catch return Errors.AllocationFailed;

        while (i < queue.items.len) : (i += 1) {
            const pair = queue.items[i];

            switch (pair.node.*) {
                .inner => |*inner| {
                    const min_keys = if (pair.depth == 0) 1 else M - 1;
                    const max_keys = 2 * M - 1;

                    // All non-root inner nodes must hold at least M - 1 keys and at most 2M - 1 keys
                    if (inner.count < min_keys or inner.count > max_keys) return Errors.ViolatedKeyInvariant;

                    // All non-root inner nodes must hold keys in ascending order
                    for (1..inner.count) |j| {
                        if (compare(inner.keys[j - 1], inner.keys[j]) != .lt) return Errors.ViolatedOrderInvariant;
                    }

                    // All children outside the count range must be null
                    for (inner.count + 1..2 * M) |j| {
                        if (inner.children[j] != null) return Errors.ViolatedNullInvariant;
                    }

                    // All inner nodes must hold non-null pointers to at least M children and at most 2M children
                    for (0..inner.count + 1) |j| {
                        if (inner.children[j]) |child| {
                            queue.append(allocator, Pair{
                                .node = child,
                                .depth = pair.depth + 1,
                            }) catch return Errors.AllocationFailed;
                        } else return Errors.ViolatedNullInvariant;
                    }
                },
                .leaf => |*leaf| {
                    // All leaves must have the same level (depth)
                    if (deepest == null) deepest = pair.depth;
                    if (pair.depth != deepest) return Errors.ViolatedDepthInvariant;

                    const min_entries = if (pair.depth == 0) 1 else M - 1;
                    const max_entries = 2 * M - 1;

                    // All leaves must hold at least M - 1 entries and at most 2M - 1 entries
                    if (leaf.count < min_entries or leaf.count > max_entries) return Errors.ViolatedKeyInvariant;

                    // The doubly linked list must be internally consistent: whatever a
                    // leaf points to via `next`/`prev` must point back to this leaf.
                    if (leaf.next) |next_node| {
                        if (next_node.leaf.prev != pair.node) return Errors.ViolatedLinkInvariant;
                    }
                    if (leaf.prev) |prev_node| {
                        if (prev_node.leaf.next != pair.node) return Errors.ViolatedLinkInvariant;
                    }
                },
            }
        }
    }

    fn orderInvariantsHold(map: *T) Errors!void {
        const size = map.count();

        {
            var iter = map.iter(.ascending);
            var visited: u64 = 0;
            var node: ?E = null;

            while (iter.next()) |next| {
                if (node) |curr| if (compare(curr.key, next.key) != .lt) return Errors.ViolatedOrderInvariant;
                visited += 1;
                node = next;
            }

            if (visited != size) return Errors.ViolatedNullInvariant;
        }

        {
            var iter = map.iter(.descending);
            var visited: u64 = 0;
            var node: ?E = null;

            while (iter.prev()) |prev| {
                if (node) |curr| if (compare(curr.key, prev.key) != .gt) return Errors.ViolatedOrderInvariant;
                visited += 1;
                node = prev;
            }

            if (visited != size) return Errors.ViolatedNullInvariant;
        }
    }
};

fn testMap(_: Context, smith: *std.testing.Smith) !void {
    const allocator = testing.allocator;

    var oracle = std.AutoHashMap(Context.K, Context.V).init(allocator);
    defer oracle.deinit();

    var map: Context.T = .init();
    defer map.deinit(allocator);

    const Operations = enum { put, get, rid };
    while (!smith.eos()) {
        const op = smith.value(Operations);
        const key = smith.value(Context.K);

        switch (op) {
            .put => {
                const value = smith.value(Context.V);

                try oracle.put(key, value);
                try map.put(allocator, key, value);

                const expected = oracle.count();
                const actual = map.count();
                try testing.expectEqual(expected, actual);
            },

            .get => {
                const expected = oracle.get(key);
                const actual = map.get(key);

                try testing.expectEqual(expected, actual);
            },

            .rid => {
                const expected = oracle.remove(key);
                const actual = map.rid(allocator, key);

                try testing.expectEqual(expected, actual);
                try testing.expectEqual(oracle.count(), map.count());
                try testing.expectEqual(oracle.get(key), map.get(key));
            },
        }

        // Validate Invariants Integrity
        try Context.nodesInvariantsHold(allocator, &map);
        try Context.orderInvariantsHold(&map);
    }
}

test "Map: Fuzz" {
    try testing.fuzz(Context{}, testMap, .{});
}

const std = @import("std");
const mem = std.mem;
const testing = std.testing;

/// `sized`: fixed inline array, never allocates.
/// `dynamic`: heap buffer that grows and shrinks.
const Variant = enum { sized, dynamic };

/// A LIFO stack of `T`. `N` is the capacity for `.sized`, or the initial
/// capacity for `.dynamic` (`0` means `4`).
///
/// `deinit` frees only the Dynamic buffer; the caller owns the stack itself.
pub fn Stack(comptime T: type, comptime N: usize, comptime V: Variant) type {
    return union(Variant) {
        const Self = @This();

        sized: Sized,
        dynamic: Dynamic,

        /// `cursor` is the index of the top item, or `null` when empty.
        const Sized = struct { cursor: ?usize, data: [N]T };

        /// `cursor` is the index of the top item, or `null` when empty.
        /// `data.len` is the capacity, not the item count.
        const Dynamic = struct { cursor: ?usize, data: []T };

        const Errors = error{
            /// `add` on a full Sized stack.
            Overflow,
            /// `pop` on an empty stack.
            Underflow,
            /// Dynamic needed to allocate but `allocator` was `null`.
            MissingAllocator,
        };

        /// Creates an empty stack. `default` fills the Sized array and is
        /// ignored for Dynamic, which allocates on the first `add`.
        pub fn init(default: T) Self {
            return switch (V) {
                .sized => .{ .sized = .{ .cursor = null, .data = @splat(default) } },
                .dynamic => .{ .dynamic = .{ .cursor = null, .data = &.{} } },
            };
        }

        /// Frees the Dynamic buffer. No-op for Sized or empty stacks.
        pub fn deinit(self: *Self, allocator: mem.Allocator) void {
            if (self.* == .dynamic and self.dynamic.cursor != null)
                allocator.free(self.dynamic.data);
        }

        /// Pushes `value`. Sized ignores `allocator` and returns `Overflow`
        /// when full. Dynamic doubles its capacity when full.
        pub fn add(self: *Self, allocator: ?mem.Allocator, value: T) !void {
            switch (self.*) {
                .sized => |*stack| {
                    if (stack.cursor) |cursor| {
                        if (cursor + 1 == stack.data.len) return Errors.Overflow;
                        stack.data[cursor + 1] = value;
                        stack.cursor.? += 1;
                    } else {
                        stack.data[0] = value;
                        stack.cursor = 0;
                    }
                },

                .dynamic => |*stack| {
                    if (stack.cursor) |cursor| {
                        if (cursor == stack.data.len - 1) {
                            if (allocator == null) return Errors.MissingAllocator;
                            const n = stack.data.len;
                            const data = try allocator.?.alloc(T, n * 2);
                            @memmove(data[0..n], stack.data);

                            allocator.?.free(stack.data);
                            stack.data = data;
                        }

                        stack.data[cursor + 1] = value;
                        stack.cursor.? += 1;
                    } else {
                        if (allocator == null) return Errors.MissingAllocator;
                        const data = try allocator.?.alloc(T, if (N == 0) 4 else N);
                        allocator.?.free(stack.data);

                        data[0] = value;
                        stack.cursor = 0;
                        stack.data = data;
                    }
                },
            }
        }

        /// Removes and returns the top item, or `Underflow` if empty.
        /// Dynamic halves its capacity when under 25% full, which needs
        /// a non-null `allocator`.
        pub fn pop(self: *Self, allocator: ?mem.Allocator) !T {
            var result: ?T = null;

            switch (self.*) {
                .sized => |*stack| {
                    if (stack.cursor) |cursor| {
                        result = stack.data[cursor];
                        switch (cursor) {
                            0 => stack.cursor = null,
                            else => stack.cursor.? -= 1,
                        }
                    } else {
                        return Errors.Underflow;
                    }
                },
                .dynamic => |*stack| {
                    if (stack.cursor) |cursor| {
                        result = stack.data[cursor];
                        switch (cursor) {
                            0 => {
                                stack.cursor = null;
                                allocator.?.free(stack.data);
                                stack.data = &.{};
                            },
                            else => {
                                stack.cursor.? -= 1;
                                if (stack.cursor.? < @divTrunc(stack.data.len, 4)) {
                                    if (allocator == null) return Errors.MissingAllocator;
                                    const n = @divTrunc(stack.data.len, 2);
                                    const data = try allocator.?.alloc(T, n);
                                    @memmove(data, stack.data[0..n]);

                                    allocator.?.free(stack.data);
                                    stack.data = data;
                                }
                            },
                        }
                    } else {
                        return Errors.Underflow;
                    }
                },
            }

            return result orelse unreachable;
        }

        /// Returns the top item without removing it, or `null` if empty.
        pub fn top(self: *Self) ?T {
            switch (self.*) {
                .sized => |stack| {
                    if (stack.cursor) |cursor|
                        return stack.data[cursor]
                    else
                        return null;
                },

                .dynamic => |stack| {
                    if (stack.cursor) |cursor|
                        return stack.data[cursor]
                    else
                        return null;
                },
            }
        }
    };
}

const Context = struct {
    const Self = @This();

    const N = 8;
    const T = u8;
    const S = Stack(T, N, .sized);
    const D = Stack(T, N, .dynamic);
    const E = S.Errors;
};

fn testSizedStack(_: Context, smith: *testing.Smith) !void {
    var oracle: [Context.N]Context.T = mem.zeroes([Context.N]Context.T);
    var stack: Context.S = .init(0);
    var cursor: ?usize = null;

    const Operations = enum { add, pop, top };
    while (!smith.eos()) {
        const op = smith.value(Operations);
        const value = smith.value(Context.T);

        switch (op) {
            .add => {
                if (cursor) |c| {
                    if (c == Context.N - 1) {
                        const expected = Context.E.Overflow;
                        const actual = stack.add(null, value);
                        try testing.expectError(expected, actual);
                    } else {
                        cursor.? += 1;
                        oracle[c + 1] = value;
                        try stack.add(null, value);
                    }
                } else {
                    cursor = 0;
                    oracle[0] = value;
                    try stack.add(null, value);
                }
            },

            .pop => {
                if (cursor) |c| {
                    const expected = oracle[c];
                    const actual = stack.pop(null);
                    try testing.expectEqual(expected, actual);

                    switch (c) {
                        0 => cursor = null,
                        else => cursor.? -= 1,
                    }
                } else {
                    const expected = Context.E.Underflow;
                    const actual = stack.pop(null);
                    try testing.expectError(expected, actual);
                }
            },

            .top => {
                const expected = if (cursor) |c| oracle[c] else null;
                const actual = stack.top();
                try testing.expectEqual(expected, actual);
            },
        }

        const expected = oracle;
        const actual = stack.sized.data;

        try testing.expectEqual(expected.len, actual.len);
        try testing.expectEqualSlices(Context.T, &expected, &actual);
    }
}

fn testDynamicStack(_: Context, smith: *testing.Smith) !void {
    const allocator = testing.allocator;

    var oracle: std.ArrayList(Context.T) = .empty;
    defer oracle.deinit(allocator);

    var stack: Context.D = .init(0);
    defer stack.deinit(allocator);

    const Operations = enum { add, pop, top };
    while (!smith.eos()) {
        const op = smith.value(Operations);
        const value = smith.value(Context.T);

        switch (op) {
            .add => {
                try oracle.append(allocator, value);
                try stack.add(allocator, value);
            },
            .pop => {
                if (stack.top() != null) {
                    const expected = oracle.pop() orelse unreachable;
                    const actual = stack.pop(allocator);
                    try testing.expectEqual(expected, actual);
                } else {
                    const expected = Context.E.Underflow;
                    const actual = stack.pop(allocator);
                    try testing.expectError(expected, actual);
                }
            },
            .top => {
                const expected = oracle.last();
                const actual = stack.top();
                try testing.expectEqual(expected, actual);
            },
        }

        const expected = oracle.items;
        const actual = stack.dynamic.data;
        const n = if (stack.dynamic.cursor) |c| c + 1 else 0;

        try testing.expectEqualSlices(Context.T, expected[0..n], actual[0..n]);
    }
}

test "Stack: Sized Fuzz" {
    try testing.fuzz(Context{}, testSizedStack, .{});
}

test "Stack: Dynamic Fuzz" {
    try testing.fuzz(Context{}, testDynamicStack, .{});
}

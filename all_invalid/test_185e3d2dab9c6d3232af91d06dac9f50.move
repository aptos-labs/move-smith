//# publish
module 0xc0ffee::struct_test {
    struct MyStruct has drop {
        count: u64,
        total: u64,
    }

    fun increment_count(self: &mut MyStruct) {
        self.count = self.count + 1;
    }

    fun add_to_total(self: &mut MyStruct, value: u64) {
        self.total = self.total + value;
    }

    public fun test_struct_update(): u64 {
        let mut s = MyStruct { count: 0, total: 0 };
        // Increment count twice
        increment_count(&mut s);
        increment_count(&mut s);
        // Add 10 to total
        add_to_total(&mut s, 10);
        // Add 20 to total
        add_to_total(&mut s, 20);
        // Compute the expression combining updated fields
        s.count + s.total
    }

    fun update_both(self: &mut MyStruct, count_inc: u64, total_add: u64) {
        self.count = self.count + count_inc;
        self.total = self.total + total_add;
    }

    public fun test_combined(): u64 {
        let mut s = MyStruct { count: 5, total: 15 };
        // Update both fields
        update_both(&mut s, 3, 7);
        // Further updates
        increment_count(&mut s);
        add_to_total(&mut s, 8);
        // Return sum of fields
        s.count + s.total
    }
}

//# run 0xc0ffee::struct_test::test_struct_update

//# run 0xc0ffee::struct_test::test_combined

//# publish
module 0x42::InlineInvoke {
    // Define an inline function that takes a function pointer with multiple args
    inline fun invoke_with_args(
        g: |u64, u64, u64| u64,
        a: u64,
        b: u64,
        c: u64
    ): u64 {
        g(a, b, c)
    }

    public fun test(): bool {
        // Use the inline function with a lambda that sums all three arguments
        let result = invoke_with_args(
            |x: u64, y: u64, z: u64| x + y + z,
            10,
            20,
            30
        );
        // Check the sum is correct
        result == 60
    }
}

//# run 0x42::InlineInvoke::test

//# publish
module 0x42::NestedInline {
    // Outer inline function that calls an inner inline function
    inline fun inner_func(x: u64): u64 {
        x + 2
    }

    inline fun outer_func(y: u64): u64 {
        // Call the inner inline function
        inner_func(y) + 3
    }
}

//# publish
module 0x42::NestedCaller {
    use 0x42::NestedInline;

    fun call_nested(z: u64): u64 {
        // Call the outer inline function which internally calls inner
        NestedInline::outer_func(z)
    }

    public fun main(): u64 {
        call_nested(4)
    }
}

//# run 0x42::NestedCaller::main
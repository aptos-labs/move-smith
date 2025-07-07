//# publish
module 0xabcde::test_module {
    // Function to increment a mutable reference by a given amount
    fun increment(r: &mut u64, delta: u64) {
        *r = *r + delta;
    }

    // Function to perform multiple increments and verify cumulative effect
    public fun perform_increments(): u64 {
        let mut total = 10;
        let r = &mut total;
        increment(r, 5);
        increment(r, 10);
        total
    }

    // Function to test that 'perform_increments' returns correct cumulative value
    public fun test(): u64 {
        perform_increments()
    }
}

//# run 0xabcde::test_module::test

//# publish
module 0xfedcb::snapshot_test {
    // Function 'fetch_and_update' accepts a mutable reference, a new value, and updates the reference.
    fun fetch_and_update(r: &mut u64, new_value: u64) {
        *r = new_value;
    }

    // Runner function to test the update behavior
    public fun run_test(): u64 {
        let mut data = 15;
        let r = &mut data;
        fetch_and_update(r, 100);
        fetch_and_update(r, 200);
        data
    }
}

//# run 0xfedcb::snapshot_test::run_test --args

//# publish
module 0x12345::ref_assignment {
    // Function test_assign assigns parameter p to local variable _x after calling one()
    fun one(): u64 {
        42
    }

    public fun test(p: u64): u64 {
        let mut _x = one();
        _x = p;
        _x
    }
}

//# run 0x12345::ref_assignment::test --args 99

//# publish
module 0x67890::tuple_sum {
    // Function creates a tuple with a fixed value and a value derived from modifying it
    fun create_tuple(): (u64, u64) {
        let a = 1;
        (a, {let mut b = a; b = b + 2; b})
    }

    public fun test(): u64 {
        let (a, b) = create_tuple();
        a + b
    }
}

//# run 0x67890::tuple_sum::test
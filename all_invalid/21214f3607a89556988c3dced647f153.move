
//# publish
module 0xCAFE::TestFeatures {
    use std::signer;
    use std::vector;

    // Internal function with internal visibility
    fun internal_helper(): u64 {
        42
    }

    // Trying to invoke internal from outside should fail
    // Uncommenting the following function call should cause compile error
    // public fun call_internal_from_outside() {
    //     internal_helper();
    // }

    // Entry script to test variable shadowing and assignments
    public fun shadowing_test() {
        let outer_var = 0u64;
        let i = 0u64;

        while (i < 3) {
            let outer_var = outer_var + i; // shadow inner variable
            let inner_var = outer_var; // local inner variable
            inner_var = inner_var + 10;
            outer_var = outer_var + 1;
            i = i + 1;
        };

        // The expected value is outer_var after loop
        // outer_var should have been incremented 3 times starting from 0
        // with shadowing variable inner inside loop, not affecting outer
        outer_var
    }

    // Test variable assignment inside and outside loops
    public fun assign_in_loop_test() {
        let x = 0u8;
        let y = 0u8;
        let counter = 0u8;

        while (counter < 2) {
            x = x + 1;
            y = y + 2;
            counter = counter + 1;
        };

        (x, y)
    }

    // Test variable shadowing with nested scopes
    public fun shadow_scope_test() {
        let x = 5u8;
        if (x > 0) {
            let x = x + 10; // shadow outer x
        };
        x // should still be 5
    }

    // Test byte string formation with b"" prefix
    public fun byte_string_test() {
        let byte_str = b"hello";
        // assert that byte_str has expected content
        // by verifying length and first byte
        (vector::length(&byte_str), *vector::borrow(&byte_str, 0))
    }

    // Try to access internal function from outside; should fail when uncommented
    // public fun call_internal() {
    //     internal_helper();
    // }

    // Variables without initial values, assigned based on condition
    public fun conditional_assignment(cond: bool): (u8, u8) {
        let a: u8;
        let b: u8;

        if (cond) {
            a = 10;
            b = 20;
        } else {
            a = 30;
            b = 40;
        };
        (a, b)
    }
}


//# run 0xCAFE::TestFeatures::shadowing_test

//# run 0xCAFE::TestFeatures::assign_in_loop_test

//# run 0xCAFE::TestFeatures::shadow_scope_test

//# run 0xCAFE::TestFeatures::byte_string_test

//# run 0xCAFE::TestFeatures::conditional_assignment --args true

//# run 0xCAFE::TestFeatures::conditional_assignment --args false


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// b76f6e38e3b59c5a2ca854dea5015a31: Create byte strings with 'b""' prefix.
// ef0d8e076c5cee0d7d3002c7d8da1efa: Ensure that variables declared without an initial value can be assigned a value within an if-else statement, and that the variable's value reflects the correct branch taken.

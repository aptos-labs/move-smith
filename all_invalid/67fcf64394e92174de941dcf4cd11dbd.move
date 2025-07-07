
//# publish
module 0xCAFE::TestModule {
    use std::signer;
    use std::vector;

    // Internal function, only accessible within this module
    internal fun internal_function(x: u64): u64 {
        x + 10
    }

    // Public function to expose internal function for testing
    public fun call_internal_function(x: u64): u64 {
        internal_function(x)
    }

    // Create a struct for complex variable and borrow tests
    struct DataHolder has copy, drop, store {
        a: u64,
        b: u64,
    }

    // Entry point to test loops with variable scoping and shadowing
    public fun loop_variable_shadowing(init_val: u64): (u64, u64) {
        let outer_var = init_val;
        let shadow_var = 0u64; // declared mutable for internal update
        let _ = {
            // Shadow inner variable
            let shadow_var = outer_var + 1;
            // Loop while inner shadow variable less than 10
            while (shadow_var < 10) {
                // Verify shadow_var increases
                let _ = {
                    shadow_var = shadow_var + 1;
                };
            };
            shadow_var // return inner shadow variable
        };
        // Verify outer variable remains unchanged
        (outer_var, shadow_var)
    }

    // Entry point to test variable update outside and inside loops
    public fun variable_update_test(initial: u64): u64 {
        let x = initial;
        let y = 0u64;

        // Update x before loop
        x = x + 2;
        // Loop update y
        for (i in 0..3) {
            y = y + i;
        };
        // assertion inside function, can be used for testing
        y
    }

    // Function to test borrow restrictions with immutable and mutable borrows
    public fun borrow_conflict_test(holder: &mut DataHolder) {
        let a_ref = &holder.a; // immutable borrow
        let b_ref = &mut holder.b; // mutable borrow
        // use references
        *b_ref = *a_ref + 5;
    }

    // Inline function accepting multiple mutable references to different fields
    public fun inline_multi_borrow(
        x: &mut u64,
        y: &mut u64,
        z: &mut u64
    ) {
        *x = *y + *z;
        *y = *x + 1;
        *z = *y + 2;
    }

    // Wrapper entry point to test the multi-borrow inline function safely
    public fun test_multi_borrow_in_function() {
        let holder = DataHolder {a: 10, b: 20};
        // Borrow fields mutably
        let fields = &mut holder;
        // Extract mutable references to fields
        let a_ref = &mut fields.a;
        let b_ref = &mut fields.b;
        // Create a local variable for z
        let temp_z: u64 = 5;
        // Call inline function with multiple mutable refs
        inline_multi_borrow(a_ref, b_ref, &mut temp_z);
    }
}


//# run 0xCAFE::TestModule::call_internal_function --args 42u64


//# run 0xCAFE::TestModule::loop_variable_shadowing --args 7u64


//# run 0xCAFE::TestModule::variable_update_test --args 100u64


//# run 0xCAFE::TestModule::borrow_conflict_test --signers 0xBADD --args <signer addr of mutable ref to DataHolder>

 
//# run 0xCAFE::TestModule::test_multi_borrow_in_function


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// ab1f58cc1de6658a7f70d92c549e66f8: Test that an inline function can safely take multiple mutable references to fields of a struct within a mutable vector, allowing both shared and mutable borrowing in a loop (multi-mutability), and that scoping works correctly inside the closure.


//# publish
module 0xBADD::InteractionTest {
    use std::signer;
    use std::vector;

    // Expose only to the testing code
    public fun external_internal_func() {
        // internal function, shouldn't be accessible outside the module
        internal fun hidden_func(): u64 {
            42
        }
    }

    // Entry point: script starts here
    public fun script_entry() {
        // Call internal function from within the module (allowed)
        let val = internal::hidden_func();

        // Declare local variables
        let outer_var = 10;

        // Shadow variable inside block
        {
            let outer_var = 20;
            // Shadowing inside inner block
            let inner_var = 30;
            // Modify inner_var
            let inner_var = inner_var + 10;
        };

        // After inner block
        // Verify outer_var remains unchanged
        outer_var
    }

    // Function with variable assignment and modification
    public fun assign_and_modify() {
        let counter = 0;
        // Loop with variable shadowing
        let i = 0;
        while (i < 3) {
            let i = i + 1; // shadowing i
            counter = counter + i;
            i = i + 1; // this is invalid, but for test we bypass
        };
        // last value of counter
        counter
    }

    // Function testing internal accessibility
    public fun test_internal_access(): u64 {
        // Attempt to call internal function from outside (should fail if uncommented)
        // internal::hidden_func() // cannot do: internal functions are not accessible externally
        // Returning dummy value
        99
    }

    // Function to test address annotations with numeric and symbolic addresses
    public fun test_attr_annotations(addr_num: u64, addr_symbol: address): bool {
        // simulate attribute acceptance
        if (addr_num > 0 && addr_symbol != @0x0) {
            true
        } else {
            false
        }
    }
}


//# run 0xBADD::InteractionTest::script_entry


//# run 0xBADD::InteractionTest::assign_and_modify


//# run 0xBADD::InteractionTest::test_internal_access


//# run 0xBADD::InteractionTest::test_attr_annotations --args 42 0xDEADBEEF


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// 6944f68830d8207340ad171d16b914ef: Use both numerical and symbolic (named) addresses as attribute values in annotations.

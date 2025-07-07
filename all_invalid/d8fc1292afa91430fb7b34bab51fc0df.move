
//# publish
module 0xCAFE::InteractionTest {
    use std::signer;
    use std::debug;

    // Re-export previous modules for testing
    use 0xCAFE::MyModule;
    use 0xCAFE::StorageUsage;

    // Internal test functions (not exported)
    public fun internal_shadow_variable_in_loop(x: u8): bool {
        let shadowed_var = x;
        // Outer variable
        let outer_var = 42u8;
        let result = false;

        // Inside while loop, shadow variable
        while (shadowed_var < 5) {
            let shadowed_var = shadowed_var + 1u8; // shadow inner variable
            if (shadowed_var == 3u8) {
                result = true;
            }
        };
        // After loop, check if outer variable remains unchanged
        debug::assert!(outer_var == 42u8, b"Outer var changed");
        result
    }

    // Verify that internal functions cannot be invoked externally
    public fun call_private_internal(): bool {
        internal_shadow_variable_in_loop(0)
    }

    // Function to test constant folding for various types
    public fun test_constant_folding(): bool {
        // u8
        let cond1 = (1u8 == 1u8);
        let cond2 = (2u8 != 3u8);
        // u64
        let cond3 = (1000u64 == 1000u64);
        let cond4 = (999u64 != 1000u64);
        // u128
        let cond5 = (999999u128 == 999999u128);
        let cond6 = (111111u128 != 222222u128);
        // bool
        let cond7 = (true == true);
        let cond8 = (false != true);
        // address
        let addr1 = @0xCAFE;
        let addr2 = @0xBABE;
        let addr_equal = (signer::address_of(&signer::borrow_signer()) == addr1);
        let addr_notequal = (addr1 != addr2);
        // bytearray (represented as vector<u8>)
        let byte1 = b"hello";
        let byte2 = b"world";
        let eq_bytes = (b"abc" == b"abc");
        let neq_bytes = (b"abc" != b"xyz");
        // bytearray with different lengths
        let eq_bytes2 = (b"abc" == b"abcd");
        // Confirm all are compile-time constants evaluated correctly
        cond1 && cond2 && cond3 && cond4 && cond5 && cond6 && cond7 && cond8 && addr_equal && addr_notequal && eq_bytes && neq_bytes && !eq_bytes2
    }

    // Function to verify script correctness for control flow and variable scope
    public fun verify_control_flow_scopes() {
        // Example: Block expression with let binding and pattern match
        let res = {
            let temp = 5u8;
            match (temp) {
                5 => {
                    let inner_var = 10u8;
                    inner_var + 1
                },
                _ => 0,
            }
        };
        debug::assert!(res == 11u8, b"Block expression failed");
        // Shadowing inside inner block
        let outer_var = 20u8;
        {
            let outer_var = 30u8; // shadow
            debug::assert!(outer_var == 30u8, b"Shadowing inside block");
        };
        debug::assert!(outer_var == 20u8, b"Outer var changed after block");
    }

    // Function to test variable interaction with loops, shadowing, and internal functions
    public fun test_variable_shadow_and_call(): bool {
        let x = 7u8;
        let result = internal_shadow_variable_in_loop(x);
        result
    }

    // Entry function to run all tests
    public fun run_all_tests() {
        // test internals: only accessible within this module
        let _ = call_private_internal();
        // verify constant folding
        let const_check = test_constant_folding();
        // verify control flow, shadowing, and block expressions
        verify_control_flow_scopes();
        // variable shadowing and internal calls
        let shadow_result = test_variable_shadow_and_call();
        // Use those results to verify overall success
        assert!(const_check, 999);
        assert!(shadow_result, 888);
    }
}


//# run 0xCAFE::InteractionTest::run_all_tests


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// ae2d61bc4b7fc3d0a9c1b3fcd6dbc137: Test that Move supports constant folding and correct evaluation of equality (==) and inequality (!=) comparisons for all primitive types (u8, u64, u128, bool, address, hex, bytearray) at compile time.
// 8d2eefbd9d86473714359d04d5e3ff42: Use the verify_script function to automatically verify scripts for correctness before deployment.
// b8a9c1c10b3e492d4bf690d9499d4e07: Use block expressions with let-bindings and pattern matching that can introduce new variable scopes and potentially modify variables within those scopes.

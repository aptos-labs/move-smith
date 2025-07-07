
//# publish
module 0xBABE::TestModule {
    use std::signer;

    // Internal function for testing internal visibility
    fun internal_increment(x: u64): u64 {
        x + 1
    }

    // Public wrapper to invoke internal_increment for testing
    public fun call_internal_increment(x: u64): u64 {
        internal_increment(x)
    }

    // Script entry point to run internal function
    public fun run_internal_increment(x: u64): u64 {
        call_internal_increment(x)
    }

    // Function to test variable shadowing in nested blocks
    public fun shadowing_test(initial_value: u64): u64 {
        let result = initial_value;
        {
            let result_shadow = result + 10; // Shadow outer result
        }; // End of block
        result // Should remain original initial_value
    }
}



//# run 0xBABE::TestModule::run_internal_increment --args 42u64



//# run 0xBABE::TestModule::shadowing_test --args 5u64



//# publish
module 0xCAFE::LoopAndScope {
    // Function to test variable updates in loop with local variables
    public fun loop_variable_test(init: u64): u64 {
        let x = init;
        let i = 0u64;
        while (i < 3) {
            // Shadow local variable in nested scope
            let x_in_loop = x + i;
            // simulate some operation, if needed
            x_in_loop = x_in_loop + 1;
            // update outer x with x_in_loop
            x = x_in_loop;
            i = i + 1;
        };
        x
    }

    // Function with nested blocks and variable shadowing
    public fun nested_shadow_test(val: u64): u64 {
        let a = val;
        {
            let a_shadow = a + 5; // shadow outer a inside block
        }; // End of block
        a // Should be original val, not affected by block change
    }
}



//# run 0xCAFE::LoopAndScope::loop_variable_test --args 10u64



//# run 0xCAFE::LoopAndScope::nested_shadow_test --args 20u64



//# publish
module 0xDEAD::Visibility {
    // Internal function (default module-private)
    fun internal_only(): u64 {
        123
    }

    // Public function to access internal function
    public fun call_internal(): u64 {
        internal_only()
    }
}



//# run 0xDEAD::Visibility::call_internal



//# publish
module 0xBEEFBEE::AddressTest {
    // Function to accept an address literal and return its bytes
    public fun address_as_bytes(addr: address): vector<u8> {
        // Convert address to bytes (not real code, just for simulation)
        // In real tests, we'd check the address literal; for now, assume it's mapped
        vector[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
    }

    // Function to test using hexadecimal address literals
    public fun test_hex_address(): vector<u8> {
        let addr1 = @0xdeadbeefcafebaben; // 'ben' suffix removed to fix syntax
        address_as_bytes(addr1)
    }
}

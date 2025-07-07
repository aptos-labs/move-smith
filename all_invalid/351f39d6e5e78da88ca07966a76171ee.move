
//# publish
module 0xCAFE::InteractionTest {
    // Use std for basic types and vector
    use std::vector;
    use std::signer;

    // Struct for testing multiple types
    struct MultiTypeStruct<T1, T2> has copy, drop, store {
        t1: T1,
        t2: T2,
    }

    // Internal resource to test visibility restrictions
    // To store this, it MUST have the `key` ability
    struct InternalSecret has key {
        secret_value: u64,
    }

    // Public, but internal to the module
    public fun create_internal_secret(s: &signer, val: u64) {
        move_to<InternalSecret>(s, InternalSecret { secret_value: val });
    }

    // Internal function (simulate with 'internal' via private scope)
    fun internal_add(x: u64, y: u64): u64 {
        x + y
    }

    // Public function that internally calls internal_add
    public fun call_internal_add(s: &signer, a: u64, b: u64): u64 {
        internal_add(a, b)
    }

    // Helper script entry point to invoke internal code
    public fun run_internal_add(s: &signer, a: u64, b: u64): u64 {
        call_internal_add(s, a, b)
    }

    // Function to test variable shadowing in loops
    public fun variable_shadowing_test() {
        let x = 0;
        let shadow_var = 100; // Shadowed variable
        let iter = 0;
        while (iter < 3) {
            // Shadowing variable inside loop
            let shadow_var = shadow_var + 1;
            // Copy the previous shadow_var value in each iteration
            x = shadow_var;
            iter = iter + 1;
        };
        // Final value of x should be 103 (initial 100 + 1 per iteration)
        assert!(x == 103, 999);
    }

    // Entry-point script that calls an internal function, manipulates variables, and uses type args
    public fun script_entry_point(s: &signer) {
        // Call to internal function (simulate usage)
        let sum = call_internal_add(s, 10, 15);
        // Create a struct with multiple types
        let _multi = MultiTypeStruct<u8, u64> { t1: 5, t2: 1000 };
        // Run variable shadowing test
        variable_shadowing_test();
        // Assert sum is correct
        assert!(sum == 25, 888);
    }
}



//# run 0xCAFE::InteractionTest::run_internal_add --signers 0xBADD --args 42u64 58u64



//# run 0xCAFE::InteractionTest::script_entry_point --signers 0xBADD


// Features:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// 47a2fb680c8ad45b47ce3cbb8cb7ce80: Define and use comma-separated lists of items (such as function parameters, struct fields, or type arguments) in Move source code.

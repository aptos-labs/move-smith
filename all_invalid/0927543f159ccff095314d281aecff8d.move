
//# publish
module 0xCAFE::AdvancedFeatureTest {
    use std::signer; // This import is unused, but leaving as per context

    // An internal-only function to test access controls
    fun internal_function_a() acquires Self : u64 {
        // Internal logic here
        42
    }

    // A private function, should not be accessible outside
    fun internal_private() acquires Self : u64 {
        99
    }

    // A public function to test access from scripts
    public fun call_internal_function() acquires Self : u64 {
        internal_function_a()
    }

    // Function with variable shadowing and reassignment
    public fun variable_shadowing_and_reassignment(): u64 {
        let x = 10u64;

        // First shadowing inside a block
        if (true) {
            let x = 20u64;
            let y = x + 5;
            let _ = y; // Use y briefly
        };

        // Reassign outer x
        let x = x + 1;
        // Shadow again after reassignment
        let x = x * 2;

        // Loop with variable shadowing inside
        let count = 0u64;
        while (count < 3) {
            let x = x + count; // shadow x inside loop
            let _ = x; // use shadowed x
            count = count + 1;
        };
        // After loop, x should be updated accordingly
        x
    }

    // Test variable initialization and shadowing with nested blocks
    public fun complex_scope_test(): (u64, u64, u64) {
        let a = 5u64;
        let b = {
            let a = a + 10; // shadow outer a
            a * 2
        };
        let c = {
            let b = b + 3; // shadow b
            b - 1
        };
        (a, b, c)
    }
}



//# run 0xCAFE::AdvancedFeatureTest::variable_shadowing_and_reassignment --args


//# run 0xCAFE::AdvancedFeatureTest::complex_scope_test --args



//# publish
module 0xDEAD::AccessControlTest {
    // Simulate call from outside
    public fun public_entrypoint() {
        // Call internal functions correctly
        let res = internal_function();
        assert!(res == 42, 1);
    }

    // Internal function only accessible within module
    fun internal_function(): u64 {
        42
    }

    // Function that tries to call private internal
    // This is not accessible from outside
    // For testing, assume invalid code doesn't compile, so no need to explicitly call.
}



//# run 0xDEAD::AccessControlTest::public_entrypoint



//# publish
module 0xFEED::ScopeShadowTest {
    use std::signer; // unused, but kept

    // Entry point to test variable scoping, shadowing, and reassignment
    public fun scope_shadowing() : u64 {
        let outer_var = 100u64;

        // Shadow in inner block
        if (true) {
            let outer_var = outer_var + 50;
            let _ = outer_var; // 150
        };
        // Shadow again
        let outer_var = outer_var * 2; // 200

        // Loop with shadowed variable
        let i = 0u64;
        while (i < 3) {
            let outer_var = outer_var + i; // shadowed inside loop
            let _ = outer_var; // Use shadowed variable
            i = i + 1;
        };
        // The outer outer_var should still be 200
        outer_var
    }

    // Function that combines local variable assignments and shadowing
    public fun combined_shadowing() : (u64, u64, u64) {
        let a = 10u64;
        let b = {
            let a = a + 20; // shadow a
            a * 2
        };
        let c = {
            let b = b + 5; // shadow b
            b - 3
        };
        (a, b, c)
    }
}



//# run 0xFEED::ScopeShadowTest::scope_shadowing


//# run 0xFEED::ScopeShadowTest::combined_shadowing

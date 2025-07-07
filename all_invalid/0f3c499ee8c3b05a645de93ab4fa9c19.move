
//# publish
module 0xCAFE::FeatureTest {
    use std::debug;
    use std::vector;

    // Struct with phantom type parameter and explicit Drop implementation
    struct PhantomStruct<T: copy + drop> has copy, drop {
        data: u64
    }

    // Internal struct with restricted visibility
    struct InternalStruct has key {
        secret: u128,
    }

    // Internal function, only callable within this module
    // Remove 'internal' keyword; Move uses 'spec' files for invariants, but 'internal' functions are not valid syntax.
    fun internal_helper(x: u64): u64 {
        x + 42
    }

    // Public function to instantiate internal structure
    public fun create_internal(secret: u128): InternalStruct {
        InternalStruct { secret }
    }

    // Test function for Drop behavior
    public fun drop_test(): () {
        let phantom: PhantomStruct<u8> = PhantomStruct { data: 123 };
        // Explicitly call drop if needed (note: Move automatically drops at scope end)
        // But to emulate explicit drop, we can just let it go out of scope.
        // move_to(&debug::get_sender_address(), phantom); // Not needed here unless moving to storage
        // For testing drop, just let scope handle it.
        // Alternatively, replace move_to with move; move is used to transfer ownership.
    }

    // Function involving shadowing and variable scope
    public fun variable_shadowing(): u64 {
        let a = 10u64;
        let a = a + 5; // Shadowed a
        let _b = {
            let a = a * 2; // Shadow within block
            a + 3
        };
        a + 1 // Should be 15 + 1 = 16
    }

    // Function with local variables inside and outside while loop
    public fun loop_variable_test(): u64 {
        let x = 0u64; // mutable for assignment
        let y = 100u64;
        while (x < y) {
            let temp = x * 2; // local inside loop
            x = x + 10;
        };
        x // After loop, x should be 100
    }

    // Function with variables outside and inside a for loop
    public fun for_loop_test(): u64 {
        let sum = 0u64;
        for (i in 0..5) {
            let inner_sum = sum + i; // shadowed inner variable
            debug::print(&inner_sum);
        };
        sum // remains 0, as not changed
    }

    // Function to test AST simplification and dead code elimination
    public fun dead_code_test(flag: bool): u64 {
        if (flag) {
            42 // live code
        } else {
            999 // dead code if flag is true; compiler should optimize away
        }
        // The dead branch should be eliminated.
        42
    }

    // Function with pseudo-invariant (simulate invariant with assertions)
    // Move does not have native 'invariant' syntax, so use assert!
    public fun invariant_function(x: u64): u64 {
        // Pseudo-invariant: x must be less than 100
        assert!(x < 100, 9999);
        let y = x + 1;
        y
    }
}



//# run 0xCAFE::FeatureTest::variable_shadowing --args


//# run 0xCAFE::FeatureTest::loop_variable_test --args


//# run 0xCAFE::FeatureTest::dead_code_test --args true


//# run 0xCAFE::FeatureTest::dead_code_test --args false


//# run 0xCAFE::FeatureTest::invariant_function --args 50

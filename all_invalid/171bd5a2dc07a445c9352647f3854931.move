
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
    internal fun internal_helper(x: u64): u64 {
        x + 42
    }

    // Public function to instantiate internal structure
    public fun create_internal(secret: u128): InternalStruct {
        InternalStruct { secret }
    }

    // Test function for Drop behavior
    public fun drop_test(): () {
        let phantom: PhantomStruct<u8> = PhantomStruct { data: 123 };
        // Explicitly call drop
        move_to(&debug::get_sender_address(), phantom);
        // "Drop" will be invoked during cleanup which is not visible here
    }

    // Function involving shadowing and variable scope
    public fun variable_shadowing(): u64 {
        let a = 10u64;
        let a = a + 5; // Shadowed a
        let _b = {
            let a = a * 2; // Shadow within block
            a + 3
        };
        a + 1 // Should be 10+5=15 plus 1 = 16
    }

    // Function with local variables inside and outside while loop
    public fun loop_variable_test(): u64 {
        let x = 0u64;
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
            999 // dead code if flag is true; compiler should optimize
        }
        // The dead branch should be eliminated.
        42
    }

    // Function with update invariant (simulate invariant declaration)
    // Note: Move does not have native syntax for invariants, but we can simulate with assertions
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


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// da5a43b09e0ae4459bb6240dbfcb3b2d: Test that a struct with a phantom type parameter and a drop ability can be instantiated and properly dropped without issues.
// b39b2c5ecfe520bd28e7d0729b418906: Enable full AST (Abstract Syntax Tree) simplification and code elimination for Move programs.
// c70d5c3e1e65b82fa6fb866dee4ef840: Specify whether an invariant is a regular invariant or an 'update' invariant by including the 'update' keyword.

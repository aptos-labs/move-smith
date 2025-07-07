
//# publish
module 0xCAFE::TestAdvancedFeatures {
    use std::signer;
    use std::vector;

    // Internal function to test visibility restriction
    fun internal_only_function(): u64 {
        42
    }

    // Public function to test purity and specification correctness
    public fun pure_function(x: u64): u64 {
        // Purity: no side effects
        x + 1
    }

    // Function to test currying / closure passing
    public fun apply_closure<F: copy + drop + fun(u64): u64>(f: F, val: u64): u64 acquires {} {
        f(val)
    }

    // Recursive helper for currying test
    public fun conditional_closure(x: u64): u64 {
        if (x > 10) {
            100
        } else {
            0
        }
    }
}


//# run 0xCAFE::TestAdvancedFeatures::internal_only_function --signers 0xDEAD // Expect failure: function is internal


//# run 0xCAFE::TestAdvancedFeatures::pure_function --args 5 --signers 0xDEAD // No explicit assertion needed


//# run 0xCAFE::TestAdvancedFeatures::apply_closure --signers 0xDEAD --args 0xCAFE::TestAdvancedFeatures::conditional_closure, 15u64
// Expect output: 100


//# run 0xCAFE::TestAdvancedFeatures::apply_closure --signers 0xDEAD --args 0xCAFE::TestAdvancedFeatures::conditional_closure, 5u64
// Expect output: 0


//# run 0xCAFE::MyModule::f1 --args 4u8 false


//# run 0xCAFE::MyModule::f3 --args 20u16

// Additional tests for variable shadowing and correctness within loops and conditions


//# publish
module 0xCAFE::LoopShadowTest {
    use std::vector;

    // Function to test variable shadowing inside while loop
    public fun shadow_vars_in_while(): u64 {
        let outer_var: u64 = 5;
        let counter: u64 = 0;

        while (counter < 3) {
            let outer_var = outer_var + counter; // Shadowing outer_var
            // Updated inner outer_var does not affect outer outer_var
            counter = counter + 1;
        };
        outer_var // Should be 5, not affected by shadowing
    }

    // Function to test variables outside and inside looping constructs
    public fun var_scope_in_loop(): (u64, u64) {
        let outside_var: u64 = 10;
        let i: u64 = 0;
        let inside_var: u64 = 0;

        while (i < 2) {
            let inside_var = outside_var + i; // Shadowing inside_var
            i = i + 1;
        };
        (outside_var, inside_var) // inside_var remains 0 outside loop
    }
}


//# run 0xCAFE::LoopShadowTest::shadow_vars_in_while --signers 0xBADA // Expect 5


//# run 0xCAFE::LoopShadowTest::var_scope_in_loop --signers 0xBADA
// Expect (10, 0)

// Verify that functions with 'internal' visibility cannot be accessed externally

//# publish
module 0xCAFE::VisibilityCheck {
    fun internal_function(): u64 {
        11
    }

    public fun caller(): u64 {
        // Call internal function from within module, should succeed
        internal_function()
    }
}


//# run 0xCAFE::VisibilityCheck::caller --signers 0xC0FF // Should succeed


//# run 0xCAFE::VisibilityCheck::internal_function --signers 0xC0FF // Expect failure: internal function not accessible outside module

// Validate specification checks with pure and impure functions

//# publish
module 0xCAFE::SpecTest {
    // A pure function with spec
    public fun check_pure(x: u64): u64 {
        x + 10
    }

    // An impure function (simulate with a side effect - in Move, side effects are via move_to or global op)
    public fun impure_side_effect(address: address): u64 {
        move_to<Void>(&signer::borrow(address), Void {});
        0
    }
}


//# run 0xCAFE::SpecTest::check_pure --args 30 --signers 0xDADA


//# run 0xCAFE::SpecTest::impure_side_effect --signers 0xDADA --args 0x12345678

// Additional tests: create higher-order functions and validate behavior


//# publish
module 0xCAFE::ClosureTests {
    // Closure with conditional logic
    public fun closure_conditional(x: u64): u64 {
        if (x > 50) {
            999
        } else {
            111
        }
    }

    // Function accepting a closure and value
    public fun execute_closure<F: copy + drop + fun(u64): u64>(f: F, val: u64): u64 {
        f(val)
    }
}


//# run 0xCAFE::ClosureTests::execute_closure --signers 0xB0B0 --args 0xCAFE::ClosureTests::closure_conditional, 70u64
// Expect 999


//# run 0xCAFE::ClosureTests::execute_closure --signers 0xB0B0 --args 0xCAFE::ClosureTests::closure_conditional, 20u64
// Expect 111


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// fdc6779e3d725d21cb1af960a124c0e2: Implement specification checking to ensure that specifications adhere to pureness and correctness standards.
// 7f343e5b6a46a90c5e940d2d1b876be9: Test that function currying with different closures correctly evaluates conditional logic and produces expected results.

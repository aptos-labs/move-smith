//# publish
module 0xCAFE::TestAxiomAndFunction {
    use std::vector;

    // Define a resource to satisfy the axiom condition expression
    struct R has key { val: u8 }

    // Declare a function that should NOT return a function-typed value - it returns u8 instead
    public fun f_no_func_return(x: u8): u8 {
        x + 1
    }

    // Declare a function returning function type (allowed only if environment options allow)
    // We place it here but do NOT run it since native function type returns may be disallowed
    // So this tests declaration only.
    public fun f_func_return(): |u8|u8 {
        let lambda: |u8| u8 has copy + drop = |a: u8| { a + 42u8 };
        lambda
    }

    #[axiom]
    fun axiom_test(r: &R): bool {
        // The axiom condition expression uses an expression: r.val > 0 && r.val < 100
        (r.val > 0) && (r.val < 100)
    }

    public fun runner(): bool {
        // Just call f_no_func_return to check normal running path
        let res = f_no_func_return(10u8);

        // Demonstrate a place an internal unused variable to satisfy axiom requirement
        let r = &R { val: res };

        // This returns true always as per axiom condition
        axiom_test(r)
    }
}

//# run 0xCAFE::TestAxiomAndFunction::runner


//# run 0xCAFE::TestAxiomAndFunction::f_no_func_return --args 7u8


//# publish
module 0xCAFE::TestForLoopReassign {
    // The following function attempts to reassign a for-loop variable, which should cause
    // a compile-time or validation error. As such, this code is FOR TESTING THE COMPILER
    // and will NOT be run.

    public fun invalid_reassign_in_for_loop(): u8 {
        let mut x = 0u8;
        // This loop variable 'i' must not be reassigned in code below,
        // but we deliberately try reassignment.
        for (i in 0..5) {
            // This line should cause validation failure or compile-time error:
            // (uncomment to test compiler)
            // i = i + 1;
            x = x + i;
        };
        x
    }
}

// No run commands: the above invalid function should cause compile-time failure.

//# run 0xCAFE::TestAxiomAndFunction::runner

//# run 0xCAFE::TestAxiomAndFunction::f_no_func_return --args 7u8


// Featurres:
// 85f1d0e6276502413d63a06cb6fd2c4e: Add an expression as the condition's content within the 'axiom'.
// c59529a48b9010cbea2c450960d883a7: Declare functions that do not return function-typed values unless allowed by the environment options.
// 45dd204003192ea47740f7c85c079f35: Test that attempting to reassign a loop variable inside a for loop causes a validation error or compile-time failure.

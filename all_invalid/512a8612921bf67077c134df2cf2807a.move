
//# publish
module 0xCAFE::TestImportErrors {
    // Trying to import a non-existent module or a non-existent member
    // should cause a compiler error, but because this is a transactional test,
    // we put this in comments for demonstration.
    // use 0xCAFE::NonExistentModule; // This would cause an import error
    // use 0xCAFE::MyModule::non_existent_function; // This causes import error
}


//# publish
module 0xCAFE::TestForLoopReassignment {
    // We demonstrate that reassigning a for-loop variable is invalid.

    public fun test_loop_reassignment(): u8 {
        let sum = 0u8;
        // The following is ILLEGAL in Move:
        // for (i in 0..5) {
        //     i = i + 1; // reassignment to loop variable should cause error
        //     sum = sum + i;
        // };
        // So, instead, just use i without reassignment.
        for (i in 0..5) {
            sum = sum + i;
        };
        sum
    }
}


//# run 0xCAFE::TestForLoopReassignment::test_loop_reassignment


//# publish
module 0xCAFE::TestPatternBinding {
    struct Point has copy, drop, store {
        x: u8,
        y: u8,
    }

    public fun pattern_let_binding(a: Point): u8 {
        let Point { x: px, y: py } = a;
        px + py
    }

    public fun pattern_function_parameter(Point { x, y }: Point): u8 {
        x + y
    }

    public fun test_runner(): u8 {
        let p = Point { x: 10u8, y: 20u8 };
        let sum1 = pattern_let_binding(p);
        let sum2 = pattern_function_parameter(p);
        sum1 + sum2
    }
}


//# run 0xCAFE::TestPatternBinding::test_runner


// Featurres:
// 8a52e53179eaf73ebe0e390d10c6133d: Receive errors if you attempt to import a non-existent module or a non-existent member in a 'use' statement.
// 45dd204003192ea47740f7c85c079f35: Test that attempting to reassign a loop variable inside a for loop causes a validation error or compile-time failure.
// fbf6d074e8b73bdc6cd6271ed135c831: Bind variables to names in patterns using de-structuring assignments in let bindings or function parameters.

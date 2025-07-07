//# publish
module 0xCAFE::BoolFuncs {
    use std::vector;

    /// A function that takes a boolean and returns the negation.
    public fun negate(b: bool): bool {
        !b
    }

    /// A function that accepts two booleans and returns their AND.
    /// It also pushes 1 to the vector `side_effect_vec` if the first argument is true,
    /// to test evaluation order.
    public fun and_with_side_effect(b1: bool, b2: bool, side_effect_vec: &mut vector<u8>): bool {
        if (b1) {
            vector::push_back(side_effect_vec, 1);
        };
        b1 && b2
    }

    /// A runner function with no arguments to test basic booleans.
    public fun runner_basic() {
        let _ = negate(true);
        let _ = negate(false);
    }

    /// A runner function to test evaluation order of function arguments.
    public fun runner_eval_order() {
        let mut side_effect_vec = vector::empty<u8>();
        // Pass true and false, pushing side effects on left argument
        let _ = Self::and_with_side_effect(true, false, &mut side_effect_vec);
        let _ = Self::and_with_side_effect(false, true, &mut side_effect_vec);
        // side_effect_vec should now have one 1 pushed from the first call
    }
}

//# run 0xCAFE::BoolFuncs::runner_basic

//# run 0xCAFE::BoolFuncs::runner_eval_order


// We create a second module with explicit dependencies to exercise Loc.

/// Declaring a module with a specific location in its module id to simulate a Loc for debugging

//# publish
module 0xCAFE::DepModule {
    public fun hello() {}
}

//# run 0xCAFE::DepModule::hello


// Now, a module using DepModule as a dependency, declared with an explicit location dependency.

//# publish
module 0xCAFE::UseDepModule {
    use 0xCAFE::DepModule;

    public fun call_hello() {
        DepModule::hello();
    }
}

//# run 0xCAFE::UseDepModule::call_hello


// Featurres:
// bce76d7eb4e4a72455e298b5a2a97100: Write boolean literals 'true' and 'false'.
// 28ec4e78c25eb370b5326ebc673bad3b: Test evaluation order of function arguments to ensure that expressions with side effects are executed left-to-right.
// 2c4163a3da60ad8ed003e9bffe966f6f: Declare dependencies with specific locations (`Loc`) to aid in debugging dependency issues.

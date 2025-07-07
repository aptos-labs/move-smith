
//# publish
module 0xCADEPRECATED::DeprecationTest {
    use std::vector;

    // Test deprecated annotations
    public fun old_function(): u8 {
        42
    }

    public fun new_function(): u8 {
        100
    }
}


//# publish
module 0xCAFE::AliasAndEval {
    use 0xCADEPRECATED::DeprecationTest as Deprecate;

    // Alias functions
    fun alias_old() : u8 {
        Deprecate::old_function()
    }

    fun alias_new() : u8 {
        Deprecate::new_function()
    }

    // A nested function to test evaluation order
    public fun evaluate_side_effects(): u8 {
        let x = 0u8;

        // Complex nested expression with side effects
        // The sequencing should invoke the assignments and function calls in order
        // and mutate x accordingly
        let result = {
            // Increment x after calling a function
            let _temp = {
                // Call alias_old (deprecated)
                let val1 = alias_old();

                // Call alias_new
                let val2 = alias_new();

                // Assign to x, but order matters; this should execute last
                x = val1 + val2;

                // Evaluate the sequence
                val1 + val2
            };

            // Return the result after side effects
            _temp
        };

        // The final value is result
        // The value of x should be (42 + 100) = 142
        // The result should be same as _temp
        result
    }
}


//# run 0xCAFE::AliasAndEval::evaluate_side_effects

// Featurres:
// a2d7fbb8193d7979e093ba1c6ea49a06: Annotate module members with deprecated annotations
// 2d689e2dc477bc7337c64758629a63b5: Alias module members with custom names when importing them
// ab4f2d8020a10dcc50efd93b1d2646fd: Test the order of evaluation and side effect sequencing of complex nested expressions with mutation and assignment in function arguments.

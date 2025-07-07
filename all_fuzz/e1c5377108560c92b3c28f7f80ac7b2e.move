
//# publish
module 0xCAFE::TestAddition {
    // Test that the Move function correctly computes the addition of two u8 values before returning a specific value.

    public fun add_then_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        // We add 10u8 to the sum before returning to check computation.
        sum + 10u8
    }

    public fun runner(): u8 {
        add_then_return_sum(5u8, 7u8)
    }
}


//# run 0xCAFE::TestAddition::runner



//# publish
module 0xCAFE::TestLambda {
    // Write functions containing lambda (anonymous function) expressions.

    public fun apply_lambda_twice(x: u8): u8 {
        let lambda: |u8|u8 has copy+drop = |a: u8| {
            // Simple lambda that multiplies input by 2
            a * 2u8
        };
        let once = lambda(x);
        let twice = lambda(once);
        twice
    }

    public fun runner(): u8 {
        apply_lambda_twice(3u8)
    }
}


//# run 0xCAFE::TestLambda::runner



//# publish
module 0xCAFE::NestedFunction {
    use 0xCAFE::TestAddition;

    // Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.

    public inline fun inline_add(a: u8, b: u8): u8 {
        // Call the add_then_return_sum function from TestAddition directly
        TestAddition::add_then_return_sum(a, b)
    }

    public fun nested_result(a: u8, b: u8): u8 {
        inline_add(a, b)
    }

    public fun runner(): u8 {
        nested_result(4u8, 6u8)
    }
}


//# run 0xCAFE::NestedFunction::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.

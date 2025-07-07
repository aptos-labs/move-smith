
//# publish
module 0xCAFE::TestAddition {
    /// Adds two u8 numbers and returns the result plus one.
    public fun add_and_increment(x: u8, y: u8): u8 {
        let sum = x + y;
        sum + 1
    }

    /// Returns 42 just as an example constant.
    public fun answer(): u8 {
        42
    }
}

//# run 0xCAFE::TestAddition::add_and_increment --args 10u8 5u8


//# publish
module 0xCAFE::TestLambda {
    /// Returns a lambda that multiplies input by 2.
    public fun get_double_lambda(): |u8| u8 has copy+drop {
        let double = |x: u8| { x * 2 };
        double
    }

    /// Calls a lambda on 10u8.
    public fun call_lambda(): u8 {
        let f = get_double_lambda();
        f(10u8)
    }
}

//# run 0xCAFE::TestLambda::call_lambda


//# publish
module 0xCAFE::NestedInlineFunctions {
    /// Inline function returns the input plus 100
    public inline fun add_100(x: u8): u8 {
        x + 100
    }

    /// Inline function calls add_100 and adds 50.
    public inline fun add_150(x: u8): u8 {
        let y = add_100(x);
        y + 50
    }

    /// Public function calls nested inline functions, adds 10 more.
    public fun call_nested(x: u8): u8 {
        let z = add_150(x);
        z + 10
    }
}

//# run 0xCAFE::NestedInlineFunctions::call_nested --args 1u8


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::NestedInlineFunctions;

    /// Calls NestedInlineFunctions' call_nested to test nested inline calls.
    public fun call_nested_indirect(x: u8): u8 {
        NestedInlineFunctions::call_nested(x)
    }
}

//# run 0xCAFE::CallerModule::call_nested_indirect --args 2u8


//# publish
module 0xCAFE::ConditionalReassignment {
    /// Compute sum of two values, possibly reassign y if condition passes, then sum again.
    public fun test(cond: bool, a: u8, b: u8): u8 {
        let x = a;
        let y = b;
        if (cond) {
            y = y + 1;
        } else {
            x = x + 1;
        };
        x + y
    }
}

//# run 0xCAFE::ConditionalReassignment::test --args true 10u8 20u8


//# run 0xCAFE::ConditionalReassignment::test --args false 10u8 20u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// e6c9221ab82795e73d9565f626f89a59: Test that calling nested inline functions from a module correctly computes the expected result when invoked through the main function.
// 81e271060b63b1a5435d554db0e920fe: Test that the `test` function correctly computes and returns the sum of conditional values, including variable reassignments based on the boolean parameter.

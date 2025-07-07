
//# publish
module 0xCAFE::AdditionModule {
    // This module tests addition of two u8 values and returns a specific value.

    public fun add_and_return(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 5
    }
}


//# run 0xCAFE::AdditionModule::add_and_return --args 10u8 20u8



//# publish
module 0xCAFE::LambdaModule {
    // Module demonstrating lambda expressions and usage.

    public fun run_lambda_example(): u8 {
        let adder: |u8, u8| u8 has copy + drop = |x: u8, y: u8| {
            x + y
        };
        let result = adder(7, 8);
        result
    }

    public fun run_lambda_complex(): (u8, u8) {
        let combine: |u8, u8| (u8, u8) has copy + drop = |x: u8, y:u8| {
            let sum = x + y;
            let diff = if (x > y) { x - y } else { y - x };
            (sum, diff)
        };
        combine(15, 10)
    }
}


//# run 0xCAFE::LambdaModule::run_lambda_example


//# run 0xCAFE::LambdaModule::run_lambda_complex



//# publish
module 0xCAFE::NestedCallModule {
    use 0xCAFE::AdditionModule;

    // Tests calling an inline function from one module in another

    public inline fun inline_addition(x: u8, y: u8): u8 {
        AdditionModule::add_and_return(x, y)
    }

    public fun run_nested_calls(x: u8, y:u8): u8 {
        inline_addition(x, y) + 10
    }
}


//# run 0xCAFE::NestedCallModule::run_nested_calls --args 3u8 4u8



//# publish
module 0xCAFE::AbilityConflict {
    // Declaring conflicting abilities before variant list

    enum Abc has copy, drop {
        A,
        B,
        C,
    }
}


//# publish
module 0xCAFE::AbilityConflictPost {
    // Declaring conflicting abilities after variant list

    enum Def {
        X, 
        Y, 
        Z,
    } has store, key;
}



//# publish
module 0xCAFE::NestedIfElse {
    // Verify nested if-else statements correctly execute

    public fun nested_if_else(x: u8): u8 {
        if (x > 10) {
            if (x < 20) {
                1
            } else {
                2
            }
        } else {
            if (x == 10) {
                3
            } else {
                4
            }
        };
        42
    }
}


//# run 0xCAFE::NestedIfElse::nested_if_else --args 5u8


//# run 0xCAFE::NestedIfElse::nested_if_else --args 15u8


//# run 0xCAFE::NestedIfElse::nested_if_else --args 10u8


//# run 0xCAFE::NestedIfElse::nested_if_else --args 25u8



//# publish
module 0xCAFE::TestOnlyExample {
    // Test function annotated with // test_only] and no // test]
    // test_only]
    public fun only_for_tests(a: u8, b: u8): u8 {
        a * b
    }
}


//# run 0xCAFE::TestOnlyExample::only_for_tests --args 7u8 8u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// c919a1cd2026b69b6a3d9484a5406c6f: Declare conflicting abilities either before or after the variant list, but not both, to avoid syntax errors.
// a891707b80970a1938797437ba7a174b: Verify that nested if-else statements correctly execute and that the function completes without triggering assertions or errors.
// 50c36c2eb027d9822b4985ebe0d099de: Annotate test functions with #[test_only] to restrict their use for certain purposes, but not in combination with #[test].

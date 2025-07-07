
//# publish
module 0xCAFE::AddAndReturn {
    public fun add_and_return(x: u8, y: u8): u8 {
        let _sum = x + y; // prefixed with _ to silence warning since unused
        // Return a fixed value after addition, e.g., 42
        42
    }
}



//# run 0xCAFE::AddAndReturn::add_and_return --args 10u8 20u8




//# publish
module 0xCAFE::LambdaTest {
    public fun run_lambda() {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            // lambda returns product of a and b
            a * b
        };
        let _result = lambda(6u8, 7u8);
    }

    public fun run_lambda_returning_tuple() {
        let pair_lambda: |u8, u8| (u8, u8) has copy+drop = |a: u8, b: u8| {
            let sum = a + b;
            let diff = if (a > b) { a - b } else { b - a };
            (sum, diff)
        };
        let (_sum, _diff) = pair_lambda(9u8, 4u8);
    }
}



//# run 0xCAFE::LambdaTest::run_lambda



//# run 0xCAFE::LambdaTest::run_lambda_returning_tuple




//# publish
module 0xCAFE::NestedCalls {

    // Removed use of 0xCAFE::MyModule per guidelines (cannot reference example modules)
    // Provide own inline function f2 here to replace MyModule::f2 for compilation and correctness.

    public inline fun inline_f2(a: u16): (u16, u16) {
        // Provide an example implementation: return (a, a * 2)
        (a, a * 2)
    }

    public fun call_inline_and_process(x: u16): u16 {
        let (a, b) = inline_f2(x);
        // Return their sum
        a + b
    }
}



//# run 0xCAFE::NestedCalls::call_inline_and_process --args 15u16




//# publish
module 0xCAFE::BooleanOps {
    public fun test_boolean_short_circuit(x: u8, _y: u8): bool {
        // Test && with local mutation
        let flag = true;
        let cond_and = (x > 5) && {
            flag = false;
            flag
        };
        // flag should be false here because right side of && evaluated

        // Reset flag
        let flag = true;
        let cond_or = (x < 5) || {
            flag = false;
            flag
        };
        // flag should remain true since left side of || is true and right not evaluated

        cond_and && !cond_or
    }
}



//# run 0xCAFE::BooleanOps::test_boolean_short_circuit --args 6u8 10u8

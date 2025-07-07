
//# publish
module 0xCAFE::MathTest {
    // Module to test addition and lambdas

    public fun add_then_return_sum(x: u8, y: u8): u8 {
        let sum = x + y;
        // Return the sum incremented by 1 for a specific known value return
        sum + 1
    }

    public fun lambda_increment(x: u8): u8 {
        let incrementer: |u8|u8 has copy+drop = |a: u8| {
            a + 1
        };
        incrementer(x)
    }

    public fun lambda_adder(x: u8, y: u8): u8 {
        let adder: |u8, u8|u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        adder(x, y)
    }
}


//# run 0xCAFE::MathTest::add_then_return_sum --args 5u8 6u8


//# run 0xCAFE::MathTest::lambda_increment --args 10u8


//# run 0xCAFE::MathTest::lambda_adder --args 12u8 13u8


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::MathTest;

    public fun call_add_then_return_sum(x: u8, y: u8): u8 {
        MathTest::add_then_return_sum(x, y)
    }

    public fun call_lambda_increment(x: u8): u8 {
        MathTest::lambda_increment(x)
    }

    public fun call_lambda_adder(x: u8, y: u8): u8 {
        MathTest::lambda_adder(x, y)
    }

    public fun runner() {
        let _ = call_add_then_return_sum(1u8, 2u8);
        let _ = call_lambda_increment(5u8);
        let _ = call_lambda_adder(7u8, 8u8);
    }
}


//# run 0xCAFE::CallerModule::call_add_then_return_sum --args 20u8 30u8


//# run 0xCAFE::CallerModule::call_lambda_increment --args 100u8


//# run 0xCAFE::CallerModule::call_lambda_adder --args 50u8 50u8


//# run 0xCAFE::CallerModule::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.

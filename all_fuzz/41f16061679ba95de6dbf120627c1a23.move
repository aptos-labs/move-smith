
//# publish
module 0xCAFE::AdditionTest {
    // Test that the Move function correctly computes the addition of two u8 values before returning a specific value.

    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        sum
    }

    public fun run_lambda_example(): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        let result = lambda(10u8, 20u8);
        result
    }
}


//# run 0xCAFE::AdditionTest::add_and_return_sum --args 5u8 7u8


//# run 0xCAFE::AdditionTest::run_lambda_example


//# publish
module 0xCAFE::NestedCallTest {
    use 0xCAFE::AdditionTest;

    // This function tests calling an inline function from another module.
    public fun call_add_and_lambda(): (u8, u8) {
        let sum = AdditionTest::add_and_return_sum(8u8, 12u8);
        let lambda_result = AdditionTest::run_lambda_example();
        (sum, lambda_result)
    }
}


//# run 0xCAFE::NestedCallTest::call_add_and_lambda


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.

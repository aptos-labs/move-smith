
//# publish
module 0xCAFE::AdditionTest {
    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        // returns sum + 5 to have a specific return value related to addition
        sum + 5
    }

    public fun test_lambda_expression(): u8 {
        let lambda: |u8, u8|u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        lambda(7, 8)
    }
}


//# run 0xCAFE::AdditionTest::add_and_return_sum --args 10u8 20u8


//# run 0xCAFE::AdditionTest::test_lambda_expression



//# publish
module 0xCAFE::NestedCallTest {
    use 0xCAFE::AdditionTest;

    // Call inline function in AdditionTest indirectly by reusing its lambda function inside another function
    public fun indirect_call_add_and_lambda(a: u8, b: u8): (u8, u8) {
        let sum_result = AdditionTest::add_and_return_sum(a, b);

        let lambda: |u8, u8|u8 has copy+drop = |x: u8, y: u8| {
            x * y
        };

        let lambda_result = lambda(a, b);
        (sum_result, lambda_result)
    }
}


//# run 0xCAFE::NestedCallTest::indirect_call_add_and_lambda --args 3u8 4u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.

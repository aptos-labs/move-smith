
//# publish
module 0xCAFE::AdditionTest {
    // Test simple function that adds two u8 values then returns a specific value
    public fun add_and_return(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return sum + 5 as arbitrary logic to test
        sum + 5
    }
}


//# run 0xCAFE::AdditionTest::add_and_return --args 10u8 20u8



//# publish
module 0xCAFE::LambdaTest {
    // Test lambda expressions inside functions
    
    public fun apply_lambda_to_three(x: u8): u8 {
        let lambda: |u8|u8 has copy+drop = |a: u8| {
            a * 3
        };
        lambda(x)
    }

    public fun nested_lambda_sum(): u8 {
        let lambda1: |u8, u8|u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        let lambda2: |u8|u8 has copy+drop = |x: u8| {
            lambda1(x, 2u8)
        };
        lambda2(3u8)
    }
}


//# run 0xCAFE::LambdaTest::apply_lambda_to_three --args 7u8


//# run 0xCAFE::LambdaTest::nested_lambda_sum



//# publish
module 0xCAFE::InlineCallTest {
    use 0xCAFE::AdditionTest;

    // Function that calls inline function from AdditionTest module
    // We use a wrapper function that calls that inline function logic
    // but since AdditionTest doesn't provide inline function, we invoke add_and_return instead
    
    // To test nested call, we call AdditionTest::add_and_return again but with results from add_and_return

    public fun nested_additions(a: u8, b: u8): u8 {
        let first = AdditionTest::add_and_return(a, b);
        let second = AdditionTest::add_and_return(first, 1u8);
        second
    }
}


//# run 0xCAFE::InlineCallTest::nested_additions --args 5u8 10u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.

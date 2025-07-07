
//# publish
module 0xCAFE::AdditionTest {
    // Test function computing addition of two u8 values and returns result + 10
    public fun add_and_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10
    }

    // Function containing lambda expressions to add and multiply two u8 values returning tuple sum, product
    public fun lambda_ops(a: u8, b: u8): (u8, u8) {
        let add_lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        let mul_lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x * y
        };
        (add_lambda(a, b), mul_lambda(a, b))
    }
}


//# publish
module 0xCAFE::NestedCallTest {
    use 0xCAFE::AdditionTest;

    // Calls AdditionTest::add_and_offset and also calls lambda_ops then adds their results
    public fun nested_calls(a: u8, b: u8): u8 {
        let offset_result = AdditionTest::add_and_offset(a, b);
        let (sum, product) = AdditionTest::lambda_ops(a, b);
        offset_result + sum + product
    }

    // Runner function with no arguments calling nested_calls with fixed inputs
    public fun run_example(): u8 {
        let result = nested_calls(3u8, 4u8);
        result
    }
}


//# run 0xCAFE::AdditionTest::add_and_offset --args 7u8 8u8


//# run 0xCAFE::AdditionTest::lambda_ops --args 5u8 6u8


//# run 0xCAFE::NestedCallTest::nested_calls --args 2u8 3u8


//# run 0xCAFE::NestedCallTest::run_example


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.

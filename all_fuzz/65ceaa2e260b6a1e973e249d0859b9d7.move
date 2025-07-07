
//# publish
module 0xCAFE::LambdaAndInlineTest {
    use std::vector;

    // Simple add function: returns a + b + 10u8
    public fun add_and_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10u8
    }

    // Function with a lambda that adds two u8 and adds 5
    public fun lambda_add(a: u8, b: u8): u8 {
        let add_f: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y + 5u8
        };
        add_f(a, b)
    }

    // Inline function returning triple of input
    public inline fun triple(x: u8): u8 {
        x * 3u8
    }
}


//# publish
module 0xCAFE::CrossModuleCaller {
    use 0xCAFE::LambdaAndInlineTest;

    // Calls add_and_offset of other module with inputs 2 and 3
    public fun call_add_and_offset(): u8 {
        LambdaAndInlineTest::add_and_offset(2u8, 3u8)
    }

    // Calls lambda_add of other module with inputs 1 and 1
    public fun call_lambda_add(): u8 {
        LambdaAndInlineTest::lambda_add(1u8, 1u8)
    }

    // Calls inline triple function of other module inside a local function
    fun call_triple_locally(x: u8): u8 {
        let y = LambdaAndInlineTest::triple(x);
        y
    }

    public fun call_triple_external(x: u8): u8 {
        call_triple_locally(x)
    }
}


//# run 0xCAFE::LambdaAndInlineTest::add_and_offset --args 4u8 5u8


//# run 0xCAFE::LambdaAndInlineTest::lambda_add --args 4u8 6u8


//# run 0xCAFE::CrossModuleCaller::call_add_and_offset


//# run 0xCAFE::CrossModuleCaller::call_lambda_add


//# run 0xCAFE::CrossModuleCaller::call_triple_external --args 7u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.

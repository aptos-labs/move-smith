
//# publish
module 0xCAFE::Adder {
    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return sum + 10 to differentiate from sum directly
        sum + 10
    }

    public fun lambda_add_and_multiply(a: u8, b: u8): (u8, u8) {
        let add: |u8, u8| (u8) has copy+drop = |x: u8, y: u8| { x + y };
        let multiply: |u8, u8| (u8) has copy+drop = |x: u8, y: u8| { x * y };

        let sum = add(a, b);
        let product = multiply(a, b);
        (sum, product)
    }
}


//# run 0xCAFE::Adder::add_and_return_sum --args 7u8 8u8


//# run 0xCAFE::Adder::lambda_add_and_multiply --args 3u8 5u8


//# publish
module 0xCAFE::NestedCall {
    use 0xCAFE::Adder;

    public inline fun inline_double_add(x: u8, y: u8): u8 {
        let (sum, _) = Adder::lambda_add_and_multiply(x, y);
        Adder::add_and_return_sum(sum, sum)
    }

    public fun runner(): u8 {
        // Use inline function and nested calls
        inline_double_add(2u8, 3u8)
    }
}


//# run 0xCAFE::NestedCall::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.

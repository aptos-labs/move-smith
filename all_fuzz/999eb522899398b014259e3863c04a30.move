
//# publish
module 0xCAFE::MathOps {
    // Basic addition function returning sum plus a fixed offset
    public fun add_and_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 5u8
    }

    // Function containing a lambda expression (anonymous function)
    public fun apply_lambda_to_add(a: u8, b: u8): u8 {
        let add = |x: u8, y: u8| {
            x + y
        };
        add(a, b)
    }

    // Lambda returning a tuple
    public fun apply_lambda_tuple(a: u8, b: u8): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy+drop = |x: u8, y: u8| {
            (x + y, x * y)
        };
        lambda(a, b)
    }

    // Loop expression with optional body - sums up 0..n
    public fun sum_range(n: u8): u8 {
        let total = 0u8;
        for (i in 0..n) {
            total = total + i;
        };
        total
    }
}


//# run 0xCAFE::MathOps::add_and_offset --args 10u8 20u8


//# run 0xCAFE::MathOps::apply_lambda_to_add --args 7u8 8u8


//# run 0xCAFE::MathOps::apply_lambda_tuple --args 3u8 4u8


//# run 0xCAFE::MathOps::sum_range --args 6u8


//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::MathOps;

    // Calls inline function from MathOps module (simulate nested calls)
    public fun nested_calls_test(a: u8, b: u8): u8 {
        let (sum, product) = MathOps::apply_lambda_tuple(a, b);
        let offset_sum = MathOps::add_and_offset(sum, 0u8);
        offset_sum
    }
}


//# run 0xCAFE::NestedCalls::nested_calls_test --args 2u8 3u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 90b396f0cda421632ed164532a7cc258: Create loop expressions with optional bodies.

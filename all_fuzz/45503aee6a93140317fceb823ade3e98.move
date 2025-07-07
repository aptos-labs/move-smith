
//# publish
module 0xCAFE::MathOps {
    // Simple addition function for u8 values
    public fun add_u8(a: u8, b: u8): u8 {
        a + b
    }

    // Function returning a specific value after performing addition of 2 u8s
    public fun compute_then_return(x: u8, y: u8): u8 {
        let sum = add_u8(x, y);
        // Return fixed value 42u8 irrespective of sum just to test
        42u8
    }
}


//# run 0xCAFE::MathOps::compute_then_return --args 10u8 32u8


//# publish
module 0xCAFE::LambdaExamples {
    // Lambda that multiplies a u8 by 2
    public fun double_value_lambda(x: u8): u8 {
        let double_fn: |u8|u8 has copy+drop = |a: u8| {
            a * 2
        };
        double_fn(x)
    }

    // Lambda that adds two u8s and returns their product
    public fun add_and_product_lambda(x: u8, y: u8): u8 {
        let add_fn: |u8, u8|u8 has copy+drop = |a: u8, b: u8| {
            let sum = a + b;
            sum * 2
        };
        add_fn(x, y)
    }
}


//# run 0xCAFE::LambdaExamples::double_value_lambda --args 21u8


//# run 0xCAFE::LambdaExamples::add_and_product_lambda --args 10u8 15u8


//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::MathOps;

    // Inline function to triple a u8 value (just for testing)
    public inline fun triple(x: u8): u8 {
        x * 3
    }

    // Function to call inline triple and add add_u8 from MathOps
    public fun nested_calls(a: u8, b: u8): u8 {
        let tripled = triple(a);
        let sum = MathOps::add_u8(tripled, b);
        sum
    }
}


//# run 0xCAFE::NestedCalls::nested_calls --args 5u8 10u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.


//# publish
module 0xCAFE::Calculator {
    // Simple addition function that returns sum + 10u8
    public fun add_and_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10u8
    }

    // Function containing a lambda expression to multiply two u8 numbers and then add 5
    public fun lambda_multiply_add(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            let product = x * y;
            product + 5u8
        };
        lambda(a, b)
    }

    // Runner function with no arguments that calls add_and_offset and lambda_multiply_add
    public fun runner(): (u8, u8) {
        let r1 = add_and_offset(2u8, 3u8);
        let r2 = lambda_multiply_add(4u8, 5u8);
        (r1, r2)
    }

    // Inline addition function as requested for feature 3
    public inline fun inline_addition(a: u16): (u16, u16) {
        (a + 1, a + 2)
    }
}



//# publish
module 0xCAFE::Caller {
    use 0xCAFE::Calculator;

    // Calls inline function from Calculator module
    public inline fun add_one_inline(x: u16): (u16, u16) {
        Calculator::inline_addition(x)
    }

    // Nested calls function that calls Calculator.runner and add_one_inline
    public fun nested_calls(): (u8, u8, u16, u16) {
        let (r1, r2) = Calculator::runner();
        let (a1, a2) = add_one_inline(100u16);
        (r1, r2, a1, a2)
    }
}



//# run 0xCAFE::Calculator::add_and_offset --args 10u8 15u8



//# run 0xCAFE::Calculator::lambda_multiply_add --args 3u8 4u8



//# run 0xCAFE::Calculator::runner



//# run 0xCAFE::Caller::nested_calls


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.

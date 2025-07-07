
//# publish
module 0xCAFE::MathOps {
    /// Adds two u8 numbers and returns the sum plus an offset
    public fun add_and_offset(a: u8, b: u8, offset: u8): u8 {
        let sum = a + b;
        sum + offset
    }

    /// Returns a lambda function that increments a u8 value by 1
    public fun get_increment_lambda(): |u8|u8 has copy+drop {
        |x: u8| { x + 1 }
    }

    /// Applies a lambda (closure) to a given value
    public fun apply_lambda(lambda: |u8|u8, value: u8): u8 {
        lambda(value)
    }

    /// Wrapper to test apply_lambda directly from a value
    public fun apply_increment(value: u8): u8 {
        let lambda = get_increment_lambda();
        apply_lambda(lambda, value)
    }
}


//# run 0xCAFE::MathOps::add_and_offset --args 10u8 20u8 5u8


//# run 0xCAFE::MathOps::apply_increment --args 5u8



//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::MathOps;

    /// Calls MathOps::add_and_offset internally with fixed offset and returns the result
    public fun call_add_and_offset(a: u8, b: u8): u8 {
        MathOps::add_and_offset(a, b, 3u8)
    }

    /// Gets a lambda from MathOps and applies it to a number
    public fun run_lambda_through_mathops(x: u8): u8 {
        let lambda = MathOps::get_increment_lambda();
        MathOps::apply_lambda(lambda, x)
    }
}


//# run 0xCAFE::NestedCalls::call_add_and_offset --args 15u8 20u8


//# run 0xCAFE::NestedCalls::run_lambda_through_mathops --args 7u8

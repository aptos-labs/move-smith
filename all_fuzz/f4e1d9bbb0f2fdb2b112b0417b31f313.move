
//# publish
module 0xCAFE::Calculator {
    /// Adds two u8 numbers and returns the sum plus a fixed increment (5).
    public fun add_and_increment(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 5
    }

    /// Returns a lambda function that multiplies input by 2.
    public fun get_double_lambda(): |u8| u8 has copy + drop {
        let double_lambda: |u8| u8 has copy + drop = |x: u8| {
            x * 2
        };
        double_lambda
    }

    /// Calls a lambda given and returns the result.
    public fun call_lambda(lambda: |u8| u8, value: u8): u8 {
        lambda(value)
    }

    /// Calls the double lambda internally and applies it to the input value.
    public fun call_double_lambda(value: u8): u8 {
        let double_lambda = get_double_lambda();
        call_lambda(double_lambda, value)
    }
}



//# run 0xCAFE::Calculator::add_and_increment --args 3u8 4u8



//# run 0xCAFE::Calculator::call_double_lambda --args 5u8



//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::Calculator;

    /// Calls Calculator::add_and_increment twice to demonstrate nested calls.
    public fun double_nested_add(a: u8, b: u8): u8 {
        let first = Calculator::add_and_increment(a, b);
        let second = Calculator::add_and_increment(first, 1);
        second
    }

    /// Gets the double lambda from Calculator and uses call_lambda to apply it.
    public fun test_lambda_call(x: u8): u8 {
        let double_lambda = Calculator::get_double_lambda();
        Calculator::call_lambda(double_lambda, x)
    }
}



//# run 0xCAFE::NestedCalls::double_nested_add --args 3u8 2u8



//# run 0xCAFE::NestedCalls::test_lambda_call --args 6u8

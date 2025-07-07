// 

//# publish
module 0xCAFE::Calculator {
    /// Simple function to add two u8 numbers and then add 42 to test computation.
    public fun add_with_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        // return sum + 42u8 as test "expected return"
        sum + 42u8
    }

    /// Function containing lambda that multiplies two u8 numbers and returns the result
    public fun multiply_lambda(a: u8, b: u8): u8 {
        let multiply: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x * y
        };
        multiply(a, b)
    }

    /// Function containing lambda that captures environment variable and adds it
    public fun add_env_lambda(a: u8): u8 {
        let offset = 5u8;
        let add_offset: |u8| u8 has copy+drop = |x: u8| {
            x + offset
        };
        add_offset(a)
    }
}

// 

//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::Calculator;

    /// Call Calculator::add_with_offset and multiply its result by 2, demonstrating nested function calls.
    public fun nested_calls(a: u8, b: u8): u8 {
        let initial_result = Calculator::add_with_offset(a, b);
        initial_result * 2
    }
}

// 

//# run 0xCAFE::Calculator::add_with_offset --args 3u8 4u8

//# run 0xCAFE::Calculator::multiply_lambda --args 5u8 6u8

//# run 0xCAFE::Calculator::add_env_lambda --args 7u8

//# run 0xCAFE::CallerModule::nested_calls --args 3u8 4u8

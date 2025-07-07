
//# publish
module 0xCAFE::Adder {
    // Simple module to test addition and lambda usage

    const BASE_VALUE: u8 = 10;

    public fun add_two_values(a: u8, b: u8): u8 {
        let sum = a + b;
        sum
    }

    public fun add_with_lambda(a: u8, b: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        add_lambda(a, b)
    }

    public fun add_base_and_value(v: u8): u8 {
        // Use const BASE_VALUE to add with v
        BASE_VALUE + v
    }

    public fun runner(): u8 {
        // This function calls add_two_values with constants and returns result
        add_two_values(3u8, 4u8)
    }
}




//# publish
module 0xCAFE::LambdaCaller {
    use 0xCAFE::Adder;

    public fun call_external_lambda(a: u8, b: u8): u8 {
        // Use the lambda function indirectly via Add with two values
        Adder::add_two_values(a, b)
    }

    public fun call_inline_via_another(a: u8): u8 {
        // Calls adder's add_base_and_value inline function
        Adder::add_base_and_value(a)
    }

    public fun runner(): u8 {
        // Calls call_external_lambda with 5 and 6
        call_external_lambda(5u8, 6u8)
    }
}




//# publish
module 0xDEAD::WrongAddressCall {
    use 0xCAFE::Adder;

    public fun call_from_wrong_address(): u8 {
        // Attempt to call a function from a different address - simulate logic
        // Real restriction of calling from different account cannot be enforced at code level,
        // but this demonstrates awareness.
        Adder::add_two_values(1u8, 1u8)
    }
}




//# run
script {
    fun main() {
        let const_a = 7u8;
        let const_b = 8u8;

        let result1 = 0xCAFE::Adder::add_two_values(const_a, const_b);
        let result2 = 0xCAFE::Adder::add_with_lambda(const_a, const_b);
        let result3 = 0xCAFE::Adder::add_base_and_value(const_b);
        let result4 = 0xCAFE::Adder::runner();

        let lambda_result = 0xCAFE::LambdaCaller::call_external_lambda(10u8, 20u8);
        let inline_result = 0xCAFE::LambdaCaller::call_inline_via_another(5u8);
        let runner_result = 0xCAFE::LambdaCaller::runner();

        let _ = 0xDEAD::WrongAddressCall::call_from_wrong_address();
    }
}

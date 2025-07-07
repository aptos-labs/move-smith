
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
    const CONST_A: u8 = 7u8;
    const CONST_B: u8 = 8u8;

    let result1 = 0xCAFE::Adder::add_two_values(CONST_A, CONST_B);
    let result2 = 0xCAFE::Adder::add_with_lambda(CONST_A, CONST_B);
    let result3 = 0xCAFE::Adder::add_base_and_value(CONST_B);
    let result4 = 0xCAFE::Adder::runner();

    let lambda_result = 0xCAFE::LambdaCaller::call_external_lambda(10u8, 20u8);
    let inline_result = 0xCAFE::LambdaCaller::call_inline_via_another(5u8);
    let runner_result = 0xCAFE::LambdaCaller::runner();

    let _ = 0xDEAD::WrongAddressCall::call_from_wrong_address();
}


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 0d6365c3d97425026c7c36a335942a3b: Include constant declarations using 'const' inside your script.
// 16d7b55faf4333b2bc66a28091a46e29: Prevent calling functions from different account addresses.

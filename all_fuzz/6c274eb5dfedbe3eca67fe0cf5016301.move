
//# publish
module 0xCAFE::Addition {
    public fun add_two_numbers(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return sum + 5 just to differentiate output
        sum + 5
    }

    public fun adder_lambda(): |u8, u8|u8 {
        let lambda: |u8, u8|u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        lambda
    }
}


//# run 0xCAFE::Addition::add_two_numbers --args 10u8 15u8


//# run 0xCAFE::Addition::adder_lambda



//# publish
module 0xCAFE::Caller {
    use 0xCAFE::Addition;

    public fun call_addition_nested(a: u8, b: u8): u8 {
        // Call add_two_numbers in Addition module
        let result = Addition::add_two_numbers(a, b);
        // Apply a lambda to add 10 to the result from Addition module function
        let add_ten_lambda: |u8|u8 has copy+drop = |x: u8| { x + 10 };
        add_ten_lambda(result)
    }

    public fun call_lambda_and_add(a: u8, b: u8): u8 {
        let lambda = Addition::adder_lambda();
        let sum = lambda(a, b);

        // Return the sum plus 20 to test nested calls with lambda
        sum + 20
    }

    public fun runner_no_args(): u8 {
        // Just calls add_two_numbers(3,4) and then adds 10 using lambda
        call_addition_nested(3, 4)
    }
}


//# run 0xCAFE::Caller::call_addition_nested --args 8u8 7u8


//# run 0xCAFE::Caller::call_lambda_and_add --args 5u8 10u8


//# run 0xCAFE::Caller::runner_no_args


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.

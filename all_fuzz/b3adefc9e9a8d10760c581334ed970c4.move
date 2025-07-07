
//# publish
module 0xCAFE::LambdaInlines {
    // Removed unused import: std::vector

    // Public struct to use unbound variable naming as example
    struct Data has copy, drop, store {
        val: u8
    }

    // Inline function that adds two u8 values and returns a specific value after addition
    public inline fun add_and_return_specific(a: u8, b: u8): u8 {
        // Remove unused local variable 'sum' to silence warning
        // let sum = a + b;
        // return 42 after addition
        42u8
    }

    // Function containing a lambda (anonymous function) expression that adds two u8 numbers
    public fun lambda_add(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        lambda(a, b)
    }

    // Public(friend) function that calls an inline function from another module and returns result
    public(friend) fun call_other_inline_lambda(lambda: |u8| u8, val: u8): u8 {
        lambda(val)
    }

    // Inline function that accepts a lambda (|u8|u8) as argument and calls it
    public inline fun inline_calls_lambda(lambda: |u8| u8, val: u8): u8 {
        lambda(val)
    }

    // Public function to bind unbound variable and use it
    public fun unbound_variable_example(): u8 {
        // use unbound variable by binding via let
        let unbound = Data { val: 100u8 };
        unbound.val
    }

    // Runner function that combines above functionality for VM execution
    public fun runner_add_lambda(): u8 {
        // test add_and_return_specific
        let res1 = add_and_return_specific(10u8, 20u8);

        // test lambda_add
        let res2 = lambda_add(5u8, 7u8);

        // define a lambda literal in-place (not assigned) for call_other_inline_lambda and inline_calls_lambda
        // Because inline functions only accept lambda literals as arguments, not variables.

        let res3 = call_other_inline_lambda(|x: u8| { x + 1 }, 3u8);
        let res4 = inline_calls_lambda(|x: u8| { x + 1 }, 4u8);

        // unpack unbound variable
        let res5 = unbound_variable_example();

        // sum all results and return
        res1 + res2 + res3 + res4 + res5
    }
}



//# run 0xCAFE::LambdaInlines::add_and_return_specific --args 2u8 3u8



//# run 0xCAFE::LambdaInlines::lambda_add --args 10u8 20u8



//# run 0xCAFE::LambdaInlines::call_other_inline_lambda --args 5u8 --signers 0xCAFE



//# run 0xCAFE::LambdaInlines::inline_calls_lambda --args 6u8 --signers 0xCAFE



//# run 0xCAFE::LambdaInlines::unbound_variable_example



//# run 0xCAFE::LambdaInlines::runner_add_lambda

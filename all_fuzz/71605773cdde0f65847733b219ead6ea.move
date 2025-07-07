
//# publish
module 0xCAFE::LambdaInlines {
    use std::vector;

    // Public struct to use unbound variable naming as example
    struct Data has copy, drop, store {
        val: u8
    }

    // Inline function that adds two u8 values and returns a specific value after addition
    public inline fun add_and_return_specific(a: u8, b: u8): u8 {
        let sum = a + b;
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

        // define a lambda for call_other_inline_lambda and inline_calls_lambda
        let test_lambda: |u8| u8 has copy+drop = |x: u8| { x + 1 };

        let res3 = call_other_inline_lambda(test_lambda, 3u8);
        let res4 = inline_calls_lambda(test_lambda, 4u8);

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


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 0778d064d9cb26412f52601417e172aa: Test that inline functions correctly accept lambda expressions as arguments and can invoke them.
// acdaa6541ebd075c38b16fddc14104f1: Specify an item as publicly accessible to friends with 'public(friend)'.
// c9065c2dc80d960aeeb504020c42311d: Use unbound variable names in your Move code and bind them to specific values or structures.

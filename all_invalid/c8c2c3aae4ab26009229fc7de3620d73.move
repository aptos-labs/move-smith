
//# publish
module 0xCAFE::AddAndLambda {
    // Simple addition function
    public fun add(x: u8, y: u8): u8 {
        let _sum = x + y;
        // Return constant 42 regardless of sum to test specific return
        42
    }

    // Function storing and calling a lambda (anonymous function)
    public fun call_lambda(x: u8, y: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        add_lambda(x, y)
    }

    // Function taking a lambda as parameter and invoking it
    public fun call_lambda_param(f: |u8, u8| u8, a: u8, b: u8): u8 {
        f(a, b)
    }
}



//# run 0xCAFE::AddAndLambda::add --args 10u8 15u8



//# run 0xCAFE::AddAndLambda::call_lambda --args 20u8 22u8



//# run 0xCAFE::AddAndLambda::call_lambda_param --args 0x0 7u8 8u8



//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::AddAndLambda;

    // Call the inline add function from AddAndLambda with fixed inputs and add 1
    public inline fun call_inline_add_and_increment(): u8 {
        let x = 5u8;
        let y = 6u8;
        let sum = AddAndLambda::call_lambda(x, y);
        sum + 1u8
    }

    // Use a nested call: call_lambda_param with a lambda that calls AddAndLambda::add
    public fun nested_lambda_call(): u8 {
        let add_wrapper: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            AddAndLambda::add(a, b)
        };
        let result = AddAndLambda::call_lambda_param(add_wrapper, 3u8, 4u8);
        result
    }

    // Runner function with no args that calls other functions
    public fun runner(account: &signer) {
        let _ = call_inline_add_and_increment();
        let _ = nested_lambda_call();
    }
}



//# run 0xCAFE::InlineCaller::call_inline_add_and_increment



//# run 0xCAFE::InlineCaller::nested_lambda_call



//# run 0xCAFE::InlineCaller::runner --signers 0xCAFE

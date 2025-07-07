
//# publish
module 0xCAFE::AdditionAndLambda {
    use std::signer;

    struct Resource has key, store {}

    // Function that adds two u8 values and returns the sum plus two
    public fun add_and_return(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 2
    }

    // Function demonstrating lambda expressions:
    // - A lambda adds two u8
    // - Another lambda takes a u8 and returns a function that doubles it
    public fun lambda_functions_example(x: u8, y: u8): u8 {
        let add_lambda: |u8, u8|u8 has copy+drop = |a: u8, b: u8| { a + b };
        let double_lambda: |u8|u8 has copy+drop = |v: u8| { v * 2 };

        let added = add_lambda(x, y);
        let doubled = double_lambda(added);
        doubled
    }

    // Function that acquires the Resource defined in this module; must be restricted here
    public fun create_resource_at_signer(s: signer) {
        let r = Resource {};
        move_to<Resource>(&s, r);
    }

    // Function that destroys the Resource defined in this module; restricted to this module's resource
    public fun destroy_resource_at_signer(s: signer) {
        let r = move_from<Resource>(signer::address_of(&s));
        let Resource {} = r;
    }
}


//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::AdditionAndLambda;

    // A wrapper that calls the inline function from AdditionAndLambda indirectly
    public fun call_add_and_return(a: u8, b: u8): u8 {
        // call directly the function defined in another module
        AdditionAndLambda::add_and_return(a, b)
    }
}


//# run 0xCAFE::AdditionAndLambda::add_and_return --args 50u8 25u8


//# run 0xCAFE::AdditionAndLambda::lambda_functions_example --args 4u8 6u8


//# run 0xCAFE::InlineCaller::call_add_and_return --args 10u8 5u8


//# run 0xCAFE::AdditionAndLambda::create_resource_at_signer --signers 0xBEEF


//# run 0xCAFE::AdditionAndLambda::destroy_resource_at_signer --signers 0xBEEF


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// a5ad5d5e05ca7b57e4a3db061d34d84c: Restrict resource acquisition to resources defined in the same module as the function.
// 0f73841b7d38953764a6f6cb7e505d4a: Use hexadecimal format for the numerical address when no named address is found.

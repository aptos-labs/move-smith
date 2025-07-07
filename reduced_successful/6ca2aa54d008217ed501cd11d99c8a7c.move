
//# publish
module 0xCAFE::TestAddLambda {
    use std::signer;

    // Simple add function that adds two u8 values + 1
    public fun add_two_values_plus_one(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 1
    }

    // Function that creates and calls a lambda that multiplies two u8 values
    public fun multiply_lambda(a: u8, b: u8): u8 {
        let mul: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x * y
        };
        mul(a, b)
    }

    // Inline function returning a tuple for testing nested call
    public inline fun inline_add_and_mul(a: u8, b: u8): (u8, u8) {
        (a + b, a * b)
    }

    // Function that calls the inline function and returns sum + product
    public fun call_inline_and_sum(a: u8, b: u8): u8 {
        let (sum, mul) = inline_add_and_mul(a, b);
        sum + mul
    }

    // Resource struct for acquired resource testing
    struct Dummy has store, key {
        val: u8
    }

    // Function to create and move the Dummy resource to signer address
    public fun acquire_resource(s: signer, v: u8) {
        let dummy = Dummy { val: v };
        move_to<Dummy>(&s, dummy);
    }

    // Function to borrow the Dummy resource and return val field
    public fun inspect_resource(s: signer): u8 {
        let dummy_ref = borrow_global<Dummy>(signer::address_of(&s));
        dummy_ref.val
    }

    // Function that acquires resource and returns its val immediately inside function environment
    public fun acquire_and_get_val(s: signer, v: u8): u8 acquires Dummy {
        let dummy = Dummy { val: v };
        move_to<Dummy>(&s, dummy);
        let dummy_ref = borrow_global<Dummy>(signer::address_of(&s));
        dummy_ref.val
    }
}


//# run 0xCAFE::TestAddLambda::add_two_values_plus_one --args 10u8 20u8


//# run 0xCAFE::TestAddLambda::multiply_lambda --args 6u8 7u8


//# run 0xCAFE::TestAddLambda::call_inline_and_sum --args 5u8 4u8


//# run 0xCAFE::TestAddLambda::acquire_resource --signers 0xABCD --args 42u8


//# run 0xCAFE::TestAddLambda::inspect_resource --signers 0xABCD


//# run 0xCAFE::TestAddLambda::acquire_and_get_val --signers 0x1234 --args 99u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 14a417963e5cadd10041053181e8b6a8: Declare acquired resources in function environments that can be inspected by compiler checks
